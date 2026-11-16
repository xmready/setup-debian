#!/usr/bin/bash

# Discussion, issues and change requests at:
#   https://github.com/xmready/setup-debian
#
# Purpose:
#   A script to install and configure incus for sandboxed development VMs
#
# Usage:
#   curl -fL https://raw.githubusercontent.com/xmready/setup-debian/main/scripts/setup-desktop-incus.sh | bash -

set -euo pipefail

red="$(tput setaf 1 2>/dev/null || true)"
green="$(tput setaf 2 2>/dev/null || true)"
yellow="$(tput setaf 3 2>/dev/null || true)"
bold="$(tput bold 2>/dev/null || true)"
reset="$(tput sgr0 2>/dev/null || true)"
bel="$(tput bel 2>/dev/null || true)"
readonly red green yellow bold reset bel

success() { local msg="$*"; printf '%s\n' "${green}${bold}success: ${msg}${reset}"; }
info() { local msg="$*"; printf '%s\n' "${yellow}${bold}info: ${msg}${reset}"; }
err() { local msg="$*"; printf '%s\n' "${red}${bold}error: ${msg}${reset}${bel}" >&2; }
die() { err "$@"; exit 1; }

apt_get() {
  sudo DEBIAN_FRONTEND=noninteractive UCF_FORCE_CONFFNEW=1 apt-get --assume-yes \
    -o Dpkg::Options::=--force-confdef \
    -o Dpkg::Options::=--force-confnew \
    "$@"
}

has_nftables() {
  sudo incus info | grep --quiet --extended-regexp '^\s+firewall: nftables$'
}

ensure_nftables() {
  if ! has_nftables; then
    sudo systemctl restart incus \
      && sudo incus admin waitready --timeout 60 \
      && has_nftables
  fi
}

get_pool_size() {
  local max_gib="$1" avail_gib

  avail_gib="$(df --output=avail --block-size=1G -- /var/lib/incus | tail -n 1 | tr -d ' ')" \
    && (( avail_gib > 0 )) \
    && printf '%s\n' "$(( avail_gib / 2 < max_gib ? avail_gib / 2 : max_gib ))"
}

exclude_address() {
  python3 -I -c '
import ipaddress
import sys

host = ipaddress.ip_address(sys.argv[1])
ranges = []

for cidr in sys.argv[2].split(","):
    network = ipaddress.ip_network(cidr)

    if host not in network:
        ranges.append(cidr)
        continue

    if host > network.network_address:
        ranges.append(f"{network.network_address}-{host - 1}")

    if host < network.broadcast_address:
        ranges.append(f"{host + 1}-{network.broadcast_address}")

print(",".join(ranges))
' "$1" "$2"
}

is_managed_network() {
  sudo incus network show "$1" 2>/dev/null | grep --quiet --line-regexp 'managed: true'
}

has_running_instances() {
  sudo incus list --format csv --columns s | grep --quiet --line-regexp 'RUNNING'
}

has_instance() {
  sudo incus info "$1" > /dev/null 2>&1
}

get_vm_cpus() {
  local max_cpus="$1" host_cpus

  host_cpus="$(nproc)" \
    && (( host_cpus > 1 )) \
    && printf '%s\n' "$(( host_cpus / 2 < max_cpus ? host_cpus / 2 : max_cpus ))"
}

get_vm_memory_mib() {
  local max_mib="$1" host_mib

  host_mib="$(awk '/^MemTotal:/ {print int($2 / 1024)}' /proc/meminfo)" \
    && (( host_mib > 1 )) \
    && printf '%s\n' "$(( host_mib / 2 < max_mib ? host_mib / 2 : max_mib ))"
}

vm_exec() {
  local name="$1"

  shift
  sudo incus exec "$name" -- "$@" < /dev/null
}

wait_for_agent() {
  local name="$1" timeout="$2" start="$SECONDS"

  until vm_exec "$name" true > /dev/null 2>&1; do
    (( SECONDS - start < timeout )) || return 1
    sleep 2
  done
}

get_debian_stable_codename() {
  local release codename

  release="$(curl -fsSL "$1")" \
    && codename="$(sed -n 's/^Codename: \([a-z][a-z]*\)$/\1/p' <<< "$release")" \
    && [[ -n "$codename" ]] \
    && printf '%s\n' "$codename"
}

has_alias() {
  incus alias list --format csv | grep --quiet "^${1},"
}

delete_partial_vm() {
  if has_instance "$1"; then
    info "deleting the partial ${1} VM..."
    sudo incus delete --force "$1"
  fi
}

main() {
  [[ "$EUID" -ne 0 ]] || die 'run as your normal sudo user, not root'

  sudo --validate || die 'sudo authentication failed'

  remote_raw_url='https://raw.githubusercontent.com'
  setup_remote_name='xmready/setup-debian'
  version="${1:-main}"
  setup_configs_url="${remote_raw_url}/${setup_remote_name}/${version}/configs"
  acl_name='sandbox'
  acl_filename='incus-sandbox-acl.yaml'
  acl_url="${setup_configs_url}/${acl_filename}"
  acl_template="$(curl -fsSL "$acl_url")" \
    || die "failed to download ${acl_filename}"
  network_name='incusbr0'
  pool_name='sandbox'
  pools_path='/var/lib/incus/storage-pools'
  pool_max_gib=150
  vm_disk_size='30GiB'
  ipv4_private_ranges='10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.64.0.0/10,169.254.0.0/16,224.0.0.0/4'
  ipv6_private_ranges='fc00::/7'
  vm_name='dev-base'
  debian_release_url='https://deb.debian.org/debian/dists/stable/Release'
  vm_user='dev'
  vm_login_alias='dev'
  vm_max_cpus=4
  vm_max_memory_mib=8192
  vm_agent_timeout=120

  info 'installing incus...'

  apt_get update \
    && apt_get install \
      btrfs-progs \
      incus \
      nftables \
      python3 \
      ufw \
    || die 'failed to install incus'

  success 'incus installed'

  info 'starting incus...'

  sudo usermod --append --groups incus-admin "$USER" \
    && sudo incus admin waitready --timeout 60 \
    && ensure_nftables \
    || die 'failed to start incus with the nftables firewall'

  success 'incus started'

  info 'setting up incus storage pool...'

  if ! sudo incus storage show "$pool_name" > /dev/null 2>&1; then
    host_fs="$(sudo findmnt --noheadings --output FSTYPE --target "$pools_path")" \
      || die 'failed to detect the host filesystem'

    if [[ "$host_fs" == 'btrfs' ]]; then
      sudo incus storage create "$pool_name" btrfs source="${pools_path}/${pool_name}" < /dev/null \
        || die 'failed to create btrfs subvolume storage pool'
    else
      pool_size="$(get_pool_size "$pool_max_gib")" \
        || die 'failed to get free disk space'

      sudo incus storage create "$pool_name" btrfs size="${pool_size}GiB" < /dev/null \
        || die 'failed to create btrfs file storage pool'
    fi
  fi

  success 'incus storage pool set up'

  info 'setting up incus network...'

  if ! is_managed_network "$network_name"; then
    ! ip link show "$network_name" > /dev/null 2>&1 \
      || die "${network_name} exists but is not managed by incus, remove it with: sudo ip link delete ${network_name}"

    sudo incus network create "$network_name" < /dev/null \
      || die 'failed to create incus network'
  fi

  success 'incus network set up'

  info 'configuring incus default profile...'

  if sudo incus profile device get default root path > /dev/null 2>&1; then
    sudo incus profile device set default root pool="$pool_name" size="$vm_disk_size" \
      || die 'failed to configure incus root disk'
  else
    sudo incus profile device add default root disk path=/ pool="$pool_name" size="$vm_disk_size" \
      || die 'failed to add incus root disk'
  fi

  if ! sudo incus profile device get default eth0 type > /dev/null 2>&1; then
    sudo incus profile device add default eth0 nic network="$network_name" name=eth0 \
      || die 'failed to add incus network device'
  fi

  success 'incus default profile configured'

  info 'configuring incus firewall rules...'

  ipv4_address="$(sudo incus network get "$network_name" ipv4.address)" \
    && ipv6_address="$(sudo incus network get "$network_name" ipv6.address)" \
    && link_local="$(ip -6 -oneline address show dev "$network_name" scope link | awk 'NR == 1 {print $4}')" \
    && attached_acls="$(sudo incus profile device get default eth0 security.acls)" \
    || die 'failed to get incus network settings'

  [[ "$ipv4_address" == */* ]] \
    || die "${network_name} needs an IPv4 address"

  [[ -z "$attached_acls" ]] || ! has_running_instances \
    || die 'stop all incus instances before updating the firewall rules'

  host_addresses="${ipv4_address%/*}"
  ipv4_reject_ranges="$(exclude_address "${ipv4_address%/*}" "$ipv4_private_ranges")" \
    || die 'failed to build IPv4 firewall rules'
  ipv6_reject_ranges="$ipv6_private_ranges"

  if [[ "$ipv6_address" == */* ]]; then
    host_addresses+=",${ipv6_address%/*}"
    ipv6_reject_ranges="$(exclude_address "${ipv6_address%/*}" "$ipv6_private_ranges")" \
      || die 'failed to build IPv6 firewall rules'
  fi

  if [[ -n "$link_local" ]]; then
    host_addresses+=",${link_local%/*}"
  fi

  acl_rules="$(printf '%s\n' "$acl_template" \
      | sed \
        --expression "s|ipv4_reject_ranges|${ipv4_reject_ranges}|" \
        --expression "s|ipv6_reject_ranges|${ipv6_reject_ranges}|" \
        --expression "s|host_addresses|${host_addresses}|")"

  if ! sudo incus network acl show "$acl_name" > /dev/null 2>&1; then
    sudo incus network acl create "$acl_name" < /dev/null \
      || die 'failed to create incus firewall rules'
  fi

  # Incus fails to edit an ACL that a profile NIC uses, so detach it while editing
  sudo incus profile device unset default eth0 security.acls \
    && sudo incus profile device unset default eth0 security.acls.default.ingress.action \
    && printf '%s\n' "$acl_rules" | sudo incus network acl edit "$acl_name" \
    && sudo incus profile device set default eth0 security.acls="$acl_name" \
    || die 'failed to configure incus firewall rules'

  success 'incus firewall rules configured'

  info 'configuring ufw for incus...'

  sudo ufw delete allow in on "$network_name" \
    && sudo ufw allow in on "$network_name" to any port 67 proto udp \
    && sudo ufw allow in on "$network_name" to any port 547 proto udp \
    && sudo ufw allow in on "$network_name" to any port 53 \
    && sudo ufw route allow in on "$network_name" \
    && sudo ufw route allow out on "$network_name" \
    || die 'failed to configure ufw for incus'

  success 'ufw configured for incus'

  info "setting up ${vm_name} VM..."

  if ! has_instance "$vm_name"; then
    vm_cpus="$(get_vm_cpus "$vm_max_cpus")" \
      && vm_memory_mib="$(get_vm_memory_mib "$vm_max_memory_mib")" \
      || die 'failed to get the host CPUs and memory'

    debian_codename="$(get_debian_stable_codename "$debian_release_url")" \
      || die 'failed to get the latest stable Debian release'

    vm_image="images:debian/${debian_codename}"

    sudo incus image info "$vm_image" > /dev/null 2>&1 \
      || die "the ${vm_image} image is not available from the Incus image server"

    trap 'delete_partial_vm "$vm_name"' EXIT
    trap 'exit 130' INT
    trap 'exit 143' TERM

    sudo incus launch "$vm_image" "$vm_name" --vm \
        --config limits.cpu="$vm_cpus" \
        --config limits.memory="${vm_memory_mib}MiB" < /dev/null \
      && wait_for_agent "$vm_name" "$vm_agent_timeout" \
      && vm_exec "$vm_name" adduser --disabled-password --comment '' "$vm_user" \
      && vm_exec "$vm_name" sh -c 'printf "%s\n" "$1 ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/$1"' sh "$vm_user" \
      && vm_exec "$vm_name" chmod 0440 "/etc/sudoers.d/${vm_user}" \
      && vm_exec "$vm_name" visudo -cf "/etc/sudoers.d/${vm_user}" \
      && sudo incus stop "$vm_name" \
      || die "failed to create ${vm_name} VM"

    trap - EXIT INT TERM
  fi

  success "${vm_name} VM set up"

  info 'adding incus login alias...'

  if ! has_alias "$vm_login_alias"; then
    incus alias add "$vm_login_alias" "exec @ARGS@ -- su --login ${vm_user}" \
      || die 'failed to add incus login alias'
  fi

  success 'incus login alias added'
}

main "$@"

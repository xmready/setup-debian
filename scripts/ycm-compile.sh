#!/usr/bin/bash

#compile YouCompleteMe with all language features
echo -e "\n$(tput setaf 3)compiling ycm\n$(tput sgr0)" \
&& cd ~/.vim/plugged/YouCompleteMe \
&& python3 install.py \
  --clangd-completer \
  --cs-completer \
  --go-completer \
  --ts-completer \
  --rust-completer \
  --java-completer \
&& echo -e "\n$(tput setaf 2)ycm compiled\n$(tput sgr0)"

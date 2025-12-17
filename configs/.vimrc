" Set Defaults {{{

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

" }}}

" Global Leader {{{

let mapleader = ','

" }}}

" Global Options {{{

set autoindent
set autoread
set background=dark
set breakindent
set completeopt=popup,menuone
set cursorcolumn
set cursorline
set encoding=utf-8
set expandtab
set formatoptions+=j
set history=1000
set ignorecase
set laststatus=2
set linebreak
set listchars+=space:_,tab:>~
set mouse=a
set noerrorbells
set noshowmode
set nowrap
set number
set scrolloff=4
set shiftwidth=2
set shortmess+=FA
set smartcase
set splitright
set splitbelow
set sessionoptions-=options
set switchbuf=usetab
set tabstop=2
set termguicolors
set title
set updatetime=100
set visualbell
set wildcharm=<C-Z>
set wildignore+=*.docx,*.pyc,*.exe,*.flv,*.xlsx
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildignore+=*.swp,*~,._*
set wildmode=longest,full

" }}}

" Global Normal Maps Non-Recursive {{{

" editing files
nnoremap <Leader>l <C-^>zz
nnoremap <Leader>s :write<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :confirm qall<CR>
nnoremap <Leader><Esc> :mksession!<CR>:xall<CR>

" cursor motions
nnoremap <silent> : :normal! ,<CR>
nnoremap <silent> k :normal! kzz<CR>
nnoremap <silent> j :normal! jzz<CR>
nnoremap <C-O> <C-O>zvzz
nnoremap <C-I> <C-I>zvzz

" scrolling
nnoremap <C-D> <C-D>zz
nnoremap <C-U> <C-U>zz

" inserting and replacing
nnoremap a zza
nnoremap A zzA
nnoremap i zzi
nnoremap I zzI
nnoremap gI zzgI
nnoremap gi zzgi
nnoremap o zzo
nnoremap O zzO
nnoremap <Leader>A g_i
nnoremap <Leader>I ^a
nnoremap <Leader>o o<CR>
nnoremap <Leader>O O<Esc>O
nnoremap <Leader>j Go<CR>
nnoremap <Leader>J Go
nnoremap <Leader>k ggO<Esc>O
nnoremap <Leader>K ggO

" deleting and changing
nnoremap dd ddzz
nnoremap D Dzz
nnoremap R zzR
nnoremap cc zzcc
nnoremap C zzC
nnoremap s zzs
nnoremap S zzS
nnoremap yy yyzz
nnoremap Y y$zz
nnoremap p pzz
nnoremap P Pzz
nnoremap <Leader>d ^d0
nnoremap <Leader>D ggdG
nnoremap <Leader>a caw
nnoremap <Leader>i ciw
nnoremap <Leader>y "0yzz
nnoremap <Leader>Y "0y$zz
nnoremap <Leader>p "0pzz
nnoremap <Leader>P "0Pzz
nnoremap <silent> <C-J> :move .+1<CR>==zz
nnoremap <silent> <C-K> :move .-2<CR>==zz

" undo and redo
nnoremap u uzvzz
nnoremap <C-R> <C-R>zvzz
nnoremap <Leader>u uzvzz
nnoremap <Leader>U :undo0<CR>zvzz
nnoremap <Leader>r <C-R>zvzz

" visual mode
nnoremap v zzv
nnoremap V zzV

" command-line mode
nnoremap <Space> :

" patterns and search commands
nnoremap <silent> n :normal! nzvzz<CR>
nnoremap <silent> N :normal! Nzvzz<CR>
nnoremap <silent> * :normal! *zvzz<CR>
nnoremap <silent> # :normal! #zvzz<CR>
nnoremap <silent> g* :normal! g*zvzz<CR>
nnoremap <silent> g# :normal! g#zvzz<CR>
nnoremap <silent> gd :normal! gdzvzz<CR>
nnoremap <silent> gD :normal! gDzvzz<CR>
nnoremap <silent> 1gd :normal! 1gdzvzz<CR>
nnoremap <silent> 1gD :normal! 1gDzvzz<CR>
nnoremap <Leader>N :nohlsearch<CR>

" windows
nnoremap <Down> <C-W>j
nnoremap <Left> <C-W>h
nnoremap <Right> <C-W>l
nnoremap <Up> <C-W>k
nnoremap <Leader>h :split<CR>
nnoremap <Leader>v :vsplit<CR>

" buffers
nnoremap <Leader>w :bdelete<CR>
nnoremap <Leader>W :bwipeout<CR>
nnoremap <PageDown> :bnext<CR>
nnoremap <PageUp> :bprevious<CR>

" folding
nnoremap <silent> za :normal! zazz<CR>
nnoremap <silent> zA :normal! zAzz<CR>
nnoremap <silent> zM :normal! zMzz<CR>
nnoremap <silent> zR :normal! zRgg<CR>
nnoremap <silent> [z :normal! [zzz<CR>
nnoremap <silent> ]z :normal! ]zzz<CR>
nnoremap <silent> zj :normal! zjzz<CR>
nnoremap <silent> zk :normal! zkzz<CR>

" terminal window support
nnoremap <Leader>t :terminal ++close ++norestore<CR>
nnoremap <Leader>T :vertical terminal ++close ++norestore<CR>

" split lines
nnoremap K i<CR><Esc>

" close pairs
nnoremap <Leader>[ a[]<Esc>i<CR><Esc>O
nnoremap <Leader>] a[]<Esc>i<CR><Esc>O
nnoremap <Leader>{ a{}<Esc>i<CR><Esc>O
nnoremap <Leader>{ a{}<Esc>i<CR><Esc>O
nnoremap <Leader>( a()<Esc>i<CR><Esc>O
nnoremap <Leader>) a()<Esc>i<CR><Esc>O

" }}}

" Global Visual Maps Non-Recursive {{{

" deleting and changing
vnoremap d zzd
vnoremap c zzc
vnoremap y zzy
vnoremap <Leader>y "0yzz
vnoremap <Leader>p "0pzz
vnoremap <Leader>P "0Pzz
vnoremap <silent> <C-J> :move '>+1<CR>gv=gvzz
vnoremap <silent> <C-K> :move '<-2<CR>gv=gvzz

" command-line mode
vnoremap <Space> :

" }}}

" Global Terminal Maps Non-Recursive {{{

tnoremap <Down> <C-W>j
tnoremap <Left> <C-W>h
tnoremap <Right> <C-W>l
tnoremap <Up> <C-W>k

" }}}

" Global Insert Abbreviations {{{

iabbrev accomodate accommodate
iabbrev acommodate accommodate
iabbrev acomodate accommodate
iabbrev accommadate accommodate
iabbrev acommadate accommodate
iabbrev accomadate accommodate
iabbrev acomadate accommodate
iabbrev acknowledgement acknowledgment
iabbrev aquire acquire
iabbrev accessable accessible
iabbrev acessible accessible
iabbrev accesible accessible
iabbrev accesable accessible
iabbrev acessable accessible
iabbrev accross across
iabbrev agression aggression
iabbrev aler alert
iabbrev laert alert
iabbrev adn and
iabbrev apparant apparent
iabbrev aparent apparent
iabbrev apparrent apparent
iabbrev aparrent apparent
iabbrev apparantly apparently
iabbrev aparantly apparently
iabbrev aparently apparently
iabbrev aparrently apparently
iabbrev apparrently apparently
iabbrev baloon balloon
iabbrev beautifull beautiful
iabbrev begining beginning
iabbrev begininng beginning
iabbrev beutiful beautiful
iabbrev beutifull beautiful
iabbrev butiful beautiful
iabbrev calender calendar
iabbrev chagne change
iabbrev cahnge change
iabbrev chagned changed
iabbrev cahnged changed
iabbrev collaegue colleague
iabbrev collegue colleague
iabbrev coleague colleague
iabbrev consciencious conscientious
iabbrev concensus consensus
iabbrev delet delete
iabbrev delte delete
iabbrev deleet delete
iabbrev dlete delete
iabbrev desciption description
iabbrev embarressed embarrassed
iabbrev embarassed embarrassed
iabbrev emberrassed embarrassed
iabbrev emberessed embarrassed
iabbrev entrepeneur entrepreneur
iabbrev entreprenur entrepreneur
iabbrev entreperneur entrepreneur
iabbrev experiance experience
iabbrev flase false
iabbrev fro for
iabbrev foer for
iabbrev fulfil fulfill
iabbrev fucntion function
iabbrev fcuntion function
iabbrev functino function
iabbrev jist gist
iabbrev goverment government
iabbrev guranteed guaranteed
iabbrev guidence guidance
iabbrev indentifier identifier
iabbrev idiosyncracy idiosyncrasy
iabbrev independant independent
iabbrev indispensible indispensable
iabbrev liasion liaison
iabbrev liason liaison
iabbrev licence license
iabbrev lisence license
iabbrev lollypop lollipop
iabbrev lolipop lollipop
iabbrev lolypop lollipop
iabbrev maintainance maintenance
iabbrev maintnance maintenance
iabbrev miscelaneous miscellaneous
iabbrev misscellaneous miscellaneous
iabbrev misscelaneous miscellaneous
iabbrev mispelled misspelled
iabbrev necesary necessary
iabbrev neccessary necessary
iabbrev necessery necessary
iabbrev occassion occasion
iabbrev ocassion occasion
iabbrev occured occurred
iabbrev occurrance occurrence
iabbrev ocurrence occurrence
iabbrev occurence occurrence
iabbrev occurance occurrence
iabbrev ocurrance occurrence
iabbrev particualr particular
iabbrev pasttime pastime
iabbrev perseverence perseverance
iabbrev persaverance perseverance
iabbrev persaverence perseverance
iabbrev persistant persistent
iabbrev postion position
iabbrev presedence precedence
iabbrev privelege privilege
iabbrev priviledge privilege
iabbrev propoganda propaganda
iabbrev phsycology psychology
iabbrev psycology psychology
iabbrev publically publicly
iabbrev recieve receive
iabbrev recieved received
iabbrev recomend recommend
iabbrev reccommend recommend
iabbrev referance reference
iabbrev refered referred
iabbrev relevent relevant
iabbrev revelant relevant
iabbrev rember remember
iabbrev remeber remember
iabbrev reminice reminisce
iabbrev reminise reminisce
iabbrev responsibilty responsibility
iabbrev restaraunt restaurant
iabbrev restaraunts restaurants
iabbrev seperate separate
iabbrev shiping shipping
iabbrev seige siege
iabbrev solider soldier
iabbrev soliders soldiers
iabbrev splcie splice
iabbrev splcied spliced
iabbrev substitue substitute
iabbrev succesful successful
iabbrev successfull successful
iabbrev sucessful successful
iabbrev supercede supersede
iabbrev truely truly
iabbrev tset test
iabbrev tsets tests
iabbrev underate underrate
iabbrev unforseen unforeseen
iabbrev unfortunatly unfortunately
iabbrev unnecesary unnecessary
iabbrev unneccessary unnecessary
iabbrev unnecessery unnecessary
iabbrev untill until
iabbrev udpate update
iabbrev udpated updated
iabbrev withold withhold
iabbrev tatoo tattoo
iabbrev teh the
iabbrev tehn then
iabbrev theif thief
iabbrev tommorrow tomorrow
iabbrev tommorow tomorrow
iabbrev tomorow tomorrow
iabbrev ture true
iabbrev vairiable variable
iabbrev varaible variable
iabbrev vairable variable
iabbrev vairiables variables
iabbrev varaibles variables
iabbrev vairables variables
iabbrev waht what
iabbrev wich which
iabbrev wierd weird

" }}}

" Ale {{{

let g:airline#extensions#ale#enabled = 1
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \ '*':          ['remove_trailing_lines', 'trim_whitespace'],
  \ 'markdown': ['remove_trailing_lines'],
  \ }

nnoremap yoa :ALEToggle<CR>
nmap     <silent> <C-P> <Plug>(ale_previous_wrap)
nmap     <silent> <C-N> <Plug>(ale_next_wrap)

" }}}

" fugitive.vim {{{

nnoremap <Leader>f :0Git<CR>
nnoremap <Leader>F :Gdiffsplit!<CR>
nnoremap <Leader>S :Gwrite<CR>

" }}}

" fzf.vim {{{

let g:fzf_layout = { 'window': { 'width': 0.99, 'height': 0.8 } }

nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>B :Lines<CR>
nnoremap <Leader>c :History:<CR>
nnoremap <Leader>C :Commands<CR>
nnoremap <Leader>e :Files<CR>
nnoremap <Leader>E :GFiles<CR>
nnoremap <Leader>m :BCommits<CR>
nnoremap <Leader>M :Commits<CR>

" }}}

" limelight.vim {{{

nnoremap <Leader>L :Limelight!!<CR>
xnoremap <Leader>L <Plug>(Limelight)

" }}}

" Netrw {{{

let g:netrw_banner = 0
let g:netrw_fastbrowse = 0
let g:netrw_keepdir = 0
let g:netrw_localcopydircmd = 'cp -r'
let g:netrw_winsize = 30

nnoremap <Leader>n :Lexplore<CR>

augroup netrw
  autocmd!
  autocmd FileType netrw setlocal bufhidden=wipe
augroup end

" }}}

" vim-airline {{{

let g:airline_powerline_fonts = 1
let g:airline_section_z = '%p%% %l/%L : %c'

" }}}

" vim-gitgutter {{{
let g:gitgutter_signs = 1

nnoremap <Leader>g :GitGutterSignsToggle<CR>
nnoremap <Leader>G :GitGutterFold<CR>
" }}}

" YouCompleteMe {{{

let g:ycm_echo_current_diagnostic = 0
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_filepath_blacklist = {
  \ 'html': 0,
  \ 'jsx': 0,
  \ 'xml': 0,
  \ }

nmap yd :YcmCompleter GoTo<CR>
nmap yD <Plug>(YCMFindSymbolInWorkspace)

" }}}

" vim-plug {{{

call plug#begin('~/.vim/plugged')

Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'npm install'}
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/limelight.vim'
Plug 'mattn/emmet-vim'
Plug 'morhetz/gruvbox'
Plug 'nordtheme/vim'
Plug 'raimondi/delimitmate'
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'srcery-colors/srcery-vim'
Plug 'tomasr/molokai'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'ycm-core/YouCompleteMe'

call plug#end()

" }}}

" Colorscheme {{{

let g:everforest_background = 'hard'
let g:onedark_terminal_italics = '1'

colorscheme onedark

" }}}

" Filetype All {{{

augroup all_files
  autocmd!
  autocmd BufNewFile * :write
augroup END

" }}}

" Filetype C-Like {{{

augroup c_like_filetypes
  autocmd!
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <F4> :execute '!cp -R $HOME/.vim/templates/js/. .' \| !npm install eslint prettier --save-dev<CR>
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <buffer> gz :silent! normal! k<CR>]/V[/:silent! s/\zs\/\=\*\{1,2} *\ze\S\{2,}\\|\S\+\zs *\*\/\ze/<CR>`<V`>:silent! g/\/\*\{1,2}\\|\*\//d<CR>`<^:nohlsearch<CR>
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <buffer> <Leader>? A<Space>?<CR>
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <buffer> <Leader><CR> o;<Left>
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <buffer> <Leader>, A;<Esc>
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <buffer> <Leader>. A {<C-O>o}<C-O>O
  autocmd FileType c,javascript,typescript,typescriptreact nnoremap <buffer> <Leader>/ g_i {<CR>}<C-O>O
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> $ ${}<Left>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> & &&
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <BAR> <BAR><BAR>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader><CR> <C-O>o;<Left>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>, <Esc>^yg_S;<Left><C-R>0
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>. <C-O>A {<C-O>o}<C-O>O
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>/ <C-O>g_ {<CR>}<C-O>O
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>? <Space>?<Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>: <Space>:<Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>= <Space>=<Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>* <Space>*<Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>- <Space>-<Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>+ <Space>+<Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>> <Space>><Space>
  autocmd FileType c,javascript,typescript,typescriptreact inoremap <buffer> <Leader>< <Space><<Space>
  autocmd FileType c,javascript,typescript,typescriptreact vnoremap <buffer> gb c/*<CR>/<C-D><Esc>P
  autocmd FileType c,javascript,typescript,typescriptreact vnoremap <buffer> gx <Esc>`<^i/* <C-O>`> */<Esc>
  autocmd FileType c,javascript,typescript,typescriptreact vnoremap <buffer> gz :silent! s/\zs\/\=\*\{1,2} *\ze\S\{2,}\\|\S\+\zs *\*\/\ze/<CR>`<V`>:silent! g/\/\*\{1,2}\\|\*\//d<CR>`<^:nohlsearch<CR>
augroup END

" }}}

" Filetype Vim {{{

augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
  autocmd FileType vim nnoremap <buffer> gz zo:silent! normal! k<CR>/".*}\{3}\d*$<CR>V?".*{\{3}\d*$<CR>:silent! g/".*}\{3}\d*$\\|".*{\{3}\d*$/d<CR>`<^:nohlsearch<CR>
  autocmd FileType vim vnoremap <buffer> gb c"<CR> }}}<Up> {{{<C-O>p<Up><C-O>f <Space>
  autocmd FileType vim vnoremap <buffer> gx :s/\(\S\)/"" \1/<CR>
  autocmd FileType vim vnoremap <buffer> gz :s/"" //<CR>
augroup END

" }}}

" Filetype HTML {{{

augroup filetype_html
  autocmd!
  autocmd BufNewFile *.html 0r ~/.vim/templates/skeleton.html
  autocmd FileType html,htmlangular nnoremap <buffer> gz :silent! normal! k<CR>/--><CR>V%:silent! s/\zs<!-- *\ze\S\+\\|\S\+\zs *-->\ze/<CR>`<V`>:silent! g/<!--\\|-->/d<CR>`<^:nohlsearch<CR>
  autocmd FileType html,htmlangular nnoremap <buffer> <Leader>, A</<C-X><C-O><C-O><Esc>F<i
  autocmd FileType html,htmlangular nnoremap <buffer> <Leader>. A<C-O>o</<C-X><C-O><C-O><Esc>O
  autocmd FileType html,htmlangular nnoremap <buffer> <Leader>/ A</<C-X><C-O><Esc>F<i<CR>
  autocmd FileType html,htmlangular inoremap <buffer> <Leader>, <Esc>A</<C-X><C-O><Esc>F<i
  autocmd FileType html,htmlangular inoremap <buffer> <Leader>. <Esc>A<Esc>o</<C-X><C-O><Esc>O
  autocmd FileType html,htmlangular inoremap <buffer> <Leader>/ <Esc>A</<C-X><C-O><Esc>F<i<CR>
  autocmd FileType html,htmlangular inoremap <buffer> <Leader>= =""<Left>
  autocmd FileType html,htmlangular vnoremap <buffer> gb c<!--<CR>--><Esc>P
  autocmd FileType html,htmlangular vnoremap <buffer> gx <Esc>`<^i<!-- <C-O>`> --><Esc>
  autocmd FileType html,htmlangular vnoremap <buffer> gz :silent! s/\zs<!-- *\ze\S\+\\|\S\+\zs *-->\ze/<CR>`<V`>:silent! g/<!--\\|-->/d<CR>`<^:nohlsearch<CR>
augroup END

" }}}

" Filetype CSS {{{

augroup filetype_css
  autocmd!
  autocmd FileType css,scss nnoremap <buffer> gz :silent! normal! k<CR>]/V[/:silent! s/\zs\/\=\*\{1,2} *\ze\S\{2,}\\|\S\+\zs *\*\/\ze/<CR>`<V`>:silent! g/\/\*\{1,2}\\|\*\//d<CR>`<^:nohlsearch<CR>
  autocmd FileType css,scss nnoremap <buffer> <Leader>, A;<Esc>
  autocmd FileType css,scss nnoremap <buffer> <Leader>. A<Space>{<CR>}<Esc>O
  autocmd FileType css,scss nnoremap <buffer> <Leader><CR> o;<Left>
  autocmd FileType css,scss inoremap <buffer> <Leader>, <Esc>^yg_S;<Left><C-R>0
  autocmd FileType css,scss inoremap <buffer> <Leader>. <C-O>A<Space>{<CR>}<C-O>O
  autocmd FileType css,scss inoremap <buffer> <Leader>= =""<Left>
  autocmd FileType css,scss vnoremap <buffer> gb c/*<CR>/<C-D><Esc>P
  autocmd FileType css,scss vnoremap <buffer> gx <Esc>`<^i/* <C-O>`> */<Esc>
  autocmd FileType css,scss vnoremap <buffer> gz :silent! s/\zs\/\=\* *\ze\S\{2,}\\|\S\+\zs *\*\/\ze/<CR>`<V`>:silent! g/\/\*\{1,2}\\|\*\//d<CR>`<^:nohlsearch<CR>
augroup END

" }}}

vim9script

# Defaults {{{
source $VIMRUNTIME/defaults.vim
# }}}

# Global Leader {{{
g:mapleader = ','
# }}}

# Global Options {{{
set autoindent
set autoread
set background=dark
set breakindent
set completeopt=popup,menuone
set cursorcolumn
set cursorline
set display=truncate
set encoding=utf-8
set expandtab
set formatoptions+=j
set history=1000
set ignorecase
set laststatus=2
set linebreak
set listchars+=space:_,tab:>~
set noerrorbells
set noshowmode
set nowrap
set nrformats-=octal
set number
set ruler
set sessionoptions-=options
set shiftwidth=2
set shortmess+=FA
set showcmd
set smartcase
set splitbelow
set splitright
set switchbuf=usetab
set tabstop=2
set termguicolors
set title
set ttimeout
set ttimeoutlen=100
set updatetime=100
set visualbell
set wildcharm=<C-Z>
set wildignore+=*.docx,*.pyc,*.exe,*.flv,*.xlsx
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
set wildignore+=*.swp,*~,._*
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
set wildmode=longest,full
# }}}

# Global Normal Maps Non-Recursive {{{
# editing files
nnoremap <Leader>l <C-^>
nnoremap <Leader>s :write<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :confirm qall<CR>
nnoremap <Leader><Esc> :mksession!<CR>:xall<CR>

# cursor motions
nnoremap : ,

# inserting and replacing
nnoremap <Leader>A g_i
nnoremap <Leader>I ^a
nnoremap <Leader>o o<CR>
nnoremap <Leader>O O<Esc>O
nnoremap <Leader>j Go<CR>
nnoremap <Leader>J Go
nnoremap <Leader>k ggO<Esc>O
nnoremap <Leader>K ggO

# deleting and changing
nnoremap Y y$
nnoremap <Leader>d "0d
nnoremap <Leader>dd "0dd
nnoremap <Leader>D "0D
nnoremap <Leader>a caw
nnoremap <Leader>i ciw
nnoremap <Leader>c "0c
nnoremap <Leader>cc "0cc
nnoremap <Leader>y "0y
nnoremap <Leader>yy "0yy
nnoremap <Leader>Y "0y$
nnoremap <Leader>p "0p
nnoremap <Leader>P "0P
nnoremap <silent> <C-J> :move .+1<CR>==
nnoremap <silent> <C-K> :move .-2<CR>==

# undo and redo
nnoremap <Leader>u u
nnoremap <Leader>U :undo0<CR>
nnoremap <Leader>r <C-R>

# command-line mode
nnoremap <Space> :

# patterns and search commands
nnoremap <Leader>N :nohlsearch<CR>

# windows
nnoremap <Down> <C-W>j
nnoremap <Left> <C-W>h
nnoremap <Right> <C-W>l
nnoremap <Up> <C-W>k
nnoremap <Leader>h :split<CR>
nnoremap <Leader>v :vsplit<CR>

# buffers
nnoremap <Leader>w :bdelete<CR>
nnoremap <Leader>W :bwipeout<CR>
nnoremap <PageDown> :bnext<CR>
nnoremap <PageUp> :bprevious<CR>

# terminal window support
nnoremap <silent> <Leader>t :terminal ++close ++norestore<CR>
nnoremap <silent> <Leader>T :vertical terminal ++close ++norestore<CR>

# split lines
nnoremap K i<CR><Esc>

# close pairs
nnoremap <Leader>[ A[]<Esc>i<CR><Esc>O
nnoremap <Leader>] A[]<Esc>i<CR><Esc>O
nnoremap <Leader>{ A{}<Esc>i<CR><Esc>O
nnoremap <Leader>{ A{}<Esc>i<CR><Esc>O
nnoremap <Leader>( A()<Esc>i<CR><Esc>O
nnoremap <Leader>) A()<Esc>i<CR><Esc>O
# }}}

# Global Visual Maps Non-Recursive {{{
# cursor motions
vnoremap : ,

# deleting and changing
vnoremap <Leader>d "0d
vnoremap <Leader>D :s/^\s*//<CR>
vnoremap <Leader>c "0c
vnoremap <Leader>s "0s
vnoremap <Leader>y "0y
vnoremap <Leader>p "0p
vnoremap <silent> <C-J> :move '>+1<CR>gv=gv
vnoremap <silent> <C-K> :move '<-2<CR>gv=gv

# command-line mode
vnoremap <Space> :
# }}}

# Global Insert and Command-Line Maps Non-Recursive {{{
noremap! <C-B> <Left>
noremap! <C-F> <Right>
noremap! <C-A> <Home>
noremap! <C-E> <End>
noremap! <C-D> <Del>
# }}}

# Global Terminal Maps Non-Recursive {{{
tnoremap <Down> <C-W>j
tnoremap <Left> <C-W>h
tnoremap <Right> <C-W>l
tnoremap <Up> <C-W>k
# }}}

# Global Insert Abbreviations {{{
iabbrev accesable accessible
iabbrev accesible accessible
iabbrev accessable accessible
iabbrev accomadate accommodate
iabbrev accommadate accommodate
iabbrev accomodate accommodate
iabbrev accross across
iabbrev acessable accessible
iabbrev acessible accessible
iabbrev acknowledgement acknowledgment
iabbrev acomadate accommodate
iabbrev acommadate accommodate
iabbrev acommodate accommodate
iabbrev acomodate accommodate
iabbrev adn and
iabbrev agression aggression
iabbrev aler alert
iabbrev aparantly apparently
iabbrev aparent apparent
iabbrev aparently apparently
iabbrev aparrent apparent
iabbrev aparrently apparently
iabbrev apparant apparent
iabbrev apparantly apparently
iabbrev apparrent apparent
iabbrev apparrently apparently
iabbrev aquire acquire
iabbrev baloon balloon
iabbrev beautifull beautiful
iabbrev begining beginning
iabbrev begininng beginning
iabbrev beutiful beautiful
iabbrev beutifull beautiful
iabbrev butiful beautiful
iabbrev cahnge change
iabbrev cahnged changed
iabbrev calender calendar
iabbrev chagne change
iabbrev chagned changed
iabbrev coleague colleague
iabbrev collaegue colleague
iabbrev collegue colleague
iabbrev concensus consensus
iabbrev consciencious conscientious
iabbrev deleet delete
iabbrev delet delete
iabbrev delte delete
iabbrev desciption description
iabbrev dlete delete
iabbrev embarassed embarrassed
iabbrev embarressed embarrassed
iabbrev emberessed embarrassed
iabbrev emberrassed embarrassed
iabbrev entrepeneur entrepreneur
iabbrev entreperneur entrepreneur
iabbrev entreprenur entrepreneur
iabbrev experiance experience
iabbrev fcuntion function
iabbrev flase false
iabbrev foer for
iabbrev fro for
iabbrev fucntion function
iabbrev fulfil fulfill
iabbrev functino function
iabbrev goverment government
iabbrev guidence guidance
iabbrev guranteed guaranteed
iabbrev idiosyncracy idiosyncrasy
iabbrev indentifier identifier
iabbrev independant independent
iabbrev indispensible indispensable
iabbrev jist gist
iabbrev laert alert
iabbrev liasion liaison
iabbrev liason liaison
iabbrev licence license
iabbrev lisence license
iabbrev lolipop lollipop
iabbrev lollypop lollipop
iabbrev lolypop lollipop
iabbrev maintainance maintenance
iabbrev maintnance maintenance
iabbrev miscelaneous miscellaneous
iabbrev mispelled misspelled
iabbrev misscelaneous miscellaneous
iabbrev misscellaneous miscellaneous
iabbrev neccessary necessary
iabbrev necesary necessary
iabbrev necessery necessary
iabbrev ocassion occasion
iabbrev occassion occasion
iabbrev occurance occurrence
iabbrev occured occurred
iabbrev occurence occurrence
iabbrev occurrance occurrence
iabbrev ocurrance occurrence
iabbrev ocurrence occurrence
iabbrev particualr particular
iabbrev pasttime pastime
iabbrev persaverance perseverance
iabbrev persaverence perseverance
iabbrev perseverence perseverance
iabbrev persistant persistent
iabbrev phsycology psychology
iabbrev postion position
iabbrev presedence precedence
iabbrev privelege privilege
iabbrev priviledge privilege
iabbrev propoganda propaganda
iabbrev psycology psychology
iabbrev publically publicly
iabbrev reccommend recommend
iabbrev recieve receive
iabbrev recieved received
iabbrev recomend recommend
iabbrev referance reference
iabbrev refered referred
iabbrev relevent relevant
iabbrev rember remember
iabbrev remeber remember
iabbrev reminice reminisce
iabbrev reminise reminisce
iabbrev responsibilty responsibility
iabbrev restaraunt restaurant
iabbrev restaraunts restaurants
iabbrev revelant relevant
iabbrev seige siege
iabbrev seperate separate
iabbrev shiping shipping
iabbrev solider soldier
iabbrev soliders soldiers
iabbrev splcie splice
iabbrev splcied spliced
iabbrev substitue substitute
iabbrev succesful successful
iabbrev successfull successful
iabbrev sucessful successful
iabbrev supercede supersede
iabbrev tatoo tattoo
iabbrev teh the
iabbrev tehn then
iabbrev theif thief
iabbrev tommorow tomorrow
iabbrev tommorrow tomorrow
iabbrev tomorow tomorrow
iabbrev truely truly
iabbrev tset test
iabbrev tsets tests
iabbrev ture true
iabbrev treu true
iabbrev teru true
iabbrev udpate update
iabbrev udpated updated
iabbrev underate underrate
iabbrev unforseen unforeseen
iabbrev unfortunatly unfortunately
iabbrev unneccessary unnecessary
iabbrev unnecesary unnecessary
iabbrev unnecessery unnecessary
iabbrev untill until
iabbrev vairable variable
iabbrev vairables variables
iabbrev vairiable variable
iabbrev vairiables variables
iabbrev varaible variable
iabbrev varaibles variables
iabbrev waht what
iabbrev wich which
iabbrev wierd weird
iabbrev withold withhold
# }}}

# Ale {{{
g:airline#extensions#ale#enabled = 1
g:ale_completion_enabled = 0
g:ale_fix_on_save = 1
g:ale_fixers = {
    '*': ['remove_trailing_lines', 'trim_whitespace'],
    'markdown': ['remove_trailing_lines'],
}

nnoremap yoa :ALEToggle<CR>
nmap <silent> <C-P> <Plug>(ale_previous_wrap)
nmap <silent> <C-N> <Plug>(ale_next_wrap)
# }}}

# Everforest {{{
g:everforest_background = 'hard'
# }}}

# Fugitive {{{
nnoremap <Leader>f :0Git<CR>
nnoremap <Leader>F :Gdiffsplit!<CR>
nnoremap <Leader>S :Gwrite<CR>
# }}}

# Fuzzbox {{{
g:fuzzbox_mappings = 0
g:fuzzbox_respect_gitignore = 0
g:fuzzbox_keymaps = {
    'menu_up': ["\<C-p>", "\<C-k>"],
    'menu_down': ["\<C-n>", "\<C-j>"],
    'cursor_begining': ["\<C-a>", "\<Home>"],
    'preview_scroll_up': ["\<Up>"],
    'preview_scroll_down': ["\<Down>"],
    'delete_all': ["\<C-u>"],
}

nnoremap <C-F> :FuzzyGrep<CR>
nnoremap <C-R> :FuzzyCmdHistory<CR>
nnoremap <Leader><Space> :FuzzyCommands<CR>
nnoremap <Leader>/ :FuzzyInBuffer<CR>
nnoremap <Leader>b :FuzzyBuffers<CR>
nnoremap <Leader>e :FuzzyFiles<CR>
nnoremap <Leader>E :FuzzyGitFiles<CR>
nnoremap <Leader>m :FuzzyMarks<CR>
nnoremap <Leader>M :FuzzyMru<CR>
# }}}

# LimeLight {{{
nnoremap <Leader>L :Limelight!!<CR>
xnoremap <Leader>L <Plug>(Limelight)
# }}}

# Netrw {{{
g:netrw_banner = 0
g:netrw_fastbrowse = 0
g:netrw_keepdir = 0
g:netrw_localcopydircmd = 'cp -r'
g:netrw_winsize = 30

nnoremap <Leader>n :Lexplore<CR>

augroup netrw
    autocmd!
    autocmd FileType netrw setlocal bufhidden=wipe
augroup end
# }}}

# OneDark {{{
g:onedark_terminal_italics = '1'
# }}}

# Airline {{{
g:airline_powerline_fonts = 1
g:airline_section_z = '%p%% %l/%L : %c'
# }}}

# GitGutter {{{
g:gitgutter_signs = 1

nnoremap <Leader>g :GitGutterSignsToggle<CR>
nnoremap <Leader>G :GitGutterFold<CR>
# }}}

# YouCompleteMe {{{
g:ycm_echo_current_diagnostic = 0
g:ycm_enable_diagnostic_highlighting = 0
g:ycm_enable_diagnostic_signs = 0
g:ycm_show_diagnostics_ui = 0
g:ycm_filepath_blacklist = {
    'html': 0,
    'jsx': 0,
    'xml': 0,
}

nmap yd :YcmCompleter GoTo<CR>
nmap yD <Plug>(YCMFindSymbolInWorkspace)
# }}}

# Vim Plug {{{
plug#begin()
Plug 'AndrewRadev/splitjoin.vim'
Plug 'airblade/vim-gitgutter'
Plug 'airblade/vim-rooter'
Plug 'ap/vim-css-color'
Plug 'dense-analysis/ale'
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'npm install'}
Plug 'joshdick/onedark.vim'
Plug 'vim-fuzzbox/fuzzbox.vim'
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
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'xmready/vim-comentador'
Plug 'ycm-core/YouCompleteMe'
plug#end()
# }}}

# Colorscheme {{{
colorscheme onedark
# }}}

# Center Cursor Vertically {{{
augroup VCenterCursor
    autocmd!
    autocmd BufEnter,WinEnter,WinNew,VimResized * &scrolloff = winheight(win_getid()) / 2
augroup END
# }}}

# Filetype All {{{
augroup all_files
    autocmd!
    autocmd BufNewFile * :write
augroup END
# }}}

# Filetype Vim {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal iskeyword-=_
    autocmd FileType vim setlocal shiftwidth=4
    autocmd FileType vim setlocal tabstop=4
    autocmd FileType vim vnoremap <buffer> <Leader>z c#<CR> }}}<Up> {{{<C-O>p<Up><C-O>f <Space>
augroup END
# }}}

# Filetype HTML {{{
augroup filetype_html
    autocmd!
    # new file actions
    autocmd BufNewFile *.html :0r ~/.vim/templates/skeleton.html
    # auto insertions
    autocmd FileType html,htmlangular nnoremap <buffer> <Leader>, A</<C-X><C-O><Esc>F<i
    autocmd FileType html,htmlangular nnoremap <buffer> <Leader>. A</<C-X><C-O><Esc>F<i<CR><Esc>O
    autocmd FileType html,htmlangular nnoremap <buffer> <Leader>/ A</<C-X><C-O><Esc>F<i<CR>
    autocmd FileType html,htmlangular nnoremap <buffer> <Leader>= a=""<Left>
augroup END
# }}}

# Filetype C Like {{{
augroup c_like_filetypes
    autocmd!
    # auto insertions
    autocmd FileType c,javascript,typescript,typescriptreact,css,scss nnoremap <buffer> <Leader>, A { ; }<Esc>F;i
    autocmd FileType c,javascript,typescript,typescriptreact,css,scss nnoremap <buffer> <Leader>. A {}<Left><CR><Esc>O;<Left>
    autocmd FileType c,javascript,typescript,typescriptreact,css,scss nnoremap <buffer> <Leader>/ g_i {}<Left><CR><Esc>O
    autocmd FileType c,javascript,typescript,typescriptreact,css,scss nnoremap <buffer> <Leader>; A;<Esc>
    autocmd FileType c,javascript,typescript,typescriptreact,css,scss nnoremap <buffer> <Leader><CR> o;<Left>
augroup END
# }}}

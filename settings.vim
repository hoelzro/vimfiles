let $MANPAGER='less'

filetype plugin on

set showcmd
set autochdir
set softtabstop=4
set tabstop=8
set shiftwidth=4
set scrolloff=3
set autoindent
set background=dark
set directory=~/.vim/swaps/,/var/tmp
set expandtab
set smarttab
set formatoptions=cqort
set mouse=
set foldminlines=3
set foldmethod=syntax
set modeline
set hls
set incsearch
set infercase
set ruler
set showmatch
set ignorecase
set smartcase
set title
set wildmenu
set complete=.,w,b,u,t,i,kspell
set dictionary=/usr/share/dict/words
set backspace=indent,eol,start
set visualbell
set noerrorbells
set t_vb=
set viewoptions=folds,cursor
set number
set listchars=eol:¬,tab:▸\ 

if &t_Co > 1
    syntax enable
endif

if has('gui_running') || &t_Co == 256
  set t_Co=256
  colorscheme peaksea
endif

let mapleader="\\"

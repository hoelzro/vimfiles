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
set directory=/var/tmp
set expandtab
set smarttab
set formatoptions=cqort
set mouse=
set foldmethod=syntax
set modeline
set hls
set incsearch
set infercase
set ruler
set showmatch
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

if &t_Co > 1
    syntax enable
endif

if &term =~ '.*-256color'
  set t_Co=256
  colorscheme peaksea
endif

let mapleader="\\"

let $MANPAGER='less'

filetype plugin indent on

set showcmd
set softtabstop=4
set tabstop=8
set shiftwidth=4
set scrolloff=3
set autoindent
set background=dark
set directory=~/.vim/swaps/,/var/tmp
set expandtab
set smarttab
set formatoptions=cqortj
set mouse=
set foldminlines=3
set foldmethod=syntax
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
set relativenumber
set listchars=eol:¬,tab:▸\ 
set tags=./tags;
set isfname-==

set laststatus=2
let &statusline = '%{ProjectRelativePath()}%=%l,%c%V   %P'

augroup ZshHistory
  autocmd!

  autocmd BufRead .zsh_history let &statusline = '%{ProjectRelativePath()} %{ReadZshCommandTime()} %=%l,%c%V   %P'
augroup END

if &t_Co > 1
    syntax enable
endif

if has('gui_running') || &t_Co == 256
  set t_Co=256
  colorscheme peaksea
endif

let mapleader="\\"

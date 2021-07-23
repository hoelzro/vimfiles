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
set foldlevelstart=3
set foldminlines=3
set foldmethod=syntax
if !has('patch-8.1.1365')
  set nomodeline
endif
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
set linebreak
set breakindent
set breakindentopt=shift:2
set showbreak=↳\ 

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

" adapted from 'setting-tabline' in Vim help
function! TabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)

  let bufvars = getbufvar(buflist[winnr - 1], '')

  if has_key(bufvars, 'topic')
    let name = bufvars['topic']
    let m = matchlist(name, '^\(\d\+\)\s\+\(.*\)')
    if !empty(m)
      let name = m[2] . '(' . m[1] . ')'
    endif
  else
    let name = bufname(buflist[winnr - 1])
  endif

  if name == ''
    let name = '[No Name]'
  endif

  return name
endfunction

function! TabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    let s .= '%' . (i + 1) . 'T'

    let s .= ' %{TabLabel(' . (i + 1) . ')} '
  endfor

  let s .= '%#TabLineFill#%T'

  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

set tabline=%!TabLine()

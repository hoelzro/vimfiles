" vim: sts=2 sw=2

let $MANPAGER='less'
let g:originalWD = getcwd()

let g:Perl_Support_Root_Dir=$HOME . '/.vim/bundle/perl-support'

perl <<PERL
  use File::Spec;

  @INC = map { File::Spec->rel2abs($_) } @INC;
PERL

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

filetype plugin on

" Assembly
let asmsyntax='nasm'

" C
let c_gnu=1
let c_space_errors=1
let c_curly_error=1
let c_syntax_for_h=1
let c_fold_blocks=1

" Doxygen
let load_doxygen_syntax=1
let doxygen_enhanced_color=1

" Haskell
let hs_highlight_types = 1
let hs_highlight_more_types = 1
"let g:haddock_browser = '/usr/bin/firefox'
"let g:haddock_docdir = '/home/rob/programming/docs/haskell/'
"autocmd BufEnter *.hs compiler ghc

" Java
let java_highlight_all=1
let java_highlight_functions=1

" JavaScript
let javaScript_fold=1

" Lisp
let lisp_rainbow=1

" Perl
let perl_include_pod=1
let perl_want_scope_in_variables=1
let perl_extended_vars=1
let perl_fold=1
let perl_nofold_packages=1

" Python
let python_highlight_space_errors=1
let python_highlight_all=1

" Ruby
let ruby_space_errors=1
let ruby_fold=1

" Shell
let is_bash=1

" SQL
let sql_type_default='mysql'

" TeX
let tex_fold_enabled=1

if &t_Co > 1
	syntax enable
	set number
endif
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

" Mappings
map <C-p> :tabprev<CR>
map <C-n> :tabnext<CR>
map gf <C-w>gf
map <C-c> :tabnew<CR>
let mapleader="\\"

map <F2> :TlistToggle<CR>
map <Leader>f $zf%

if &term == 'xterm-256color'
  colorscheme peaksea
endif

" Automatic saving and loading of views
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview

" I hate end of line whitespace...highlight it
match Search /\s\+$/

" Doxygen helper settings
let g:DoxygenToolkit_authorName="Rob Hoelz"
map \dxa :DoxAuthor<CR>
map \dxd :Dox<CR>

let perlhelp_prog = "cpandoc"
if !executable(perlhelp_prog)
  unlet perlhelp_prog
endif

function InsertHeader()
  if !exists('b:comment_char')
    let b:comment_char = input("What's the comment character for the language in which you're working? ")
  endif

  let text = input('Header: ')
  let len = strlen(text)

  let len = len + 2
  let padding = repeat(b:comment_char, (80 - len) / 2)
  let text = padding . ' ' . text . ' ' . padding
  if len % 2 != 0
    let text = text . b:comment_char
  endif

  call append(line('.') - 1, text)
endfunction

map <Leader>i :call InsertHeader()<CR>

let g:keywordTypes = ['a-z,A-Z', 'a-z,A-Z,48-57', 'a-z,A-Z,48-57,_', 'a-z,A-Z,48-57,_,:']
let g:keywordNames = ['word', 'alphanumeric', 'C identifier', 'Perl identifier']

function RotateKeywords()
  if !exists('b:keywordIndex')
    let b:keywordIndex = 0
  endif

  let b:keywordIndex = b:keywordIndex + 1
  if b:keywordIndex == len(g:keywordTypes)
    let b:keywordIndex = 0
  endif

  let &iskeyword = g:keywordTypes[b:keywordIndex]
  echo g:keywordNames[b:keywordIndex]
endfunction

map <Leader>tt :call RotateKeywords()<CR>

" what about ($@%&)?(...) and $#array, $#$aref?
" STRINGS! "(.*)"; '(.*)'

set viewoptions=folds,cursor
let g:in_sql_mode = 0
function ToggleSQLMode()
  let l:sql_keywords = [ 'ABORT', 'ACTION', 'ADD', 'AFTER', 'ALL', 'ALTER', 'ANALYZE', 'AND', 'AS', 'ASC', 'ATTACH', 'AUTOINCREMENT', 'BEFORE', 'BEGIN', 'BETWEEN', 'BY', 'CASCADE', 'CASE', 'CAST', 'CHECK', 'COLLATE', 'COLUMN', 'COMMIT', 'CONFLICT', 'CONSTRAINT', 'CREATE', 'CROSS', 'CURRENT_DATE', 'CURRENT_TIME', 'CURRENT_TIMESTAMP', 'DATABASE', 'DEFAULT', 'DEFERRABLE', 'DEFERRED', 'DELETE', 'DESC', 'DETACH', 'DISTINCT', 'DROP', 'EACH', 'ELSE', 'END', 'ESCAPE', 'EXCEPT', 'EXCLUSIVE', 'EXISTS', 'EXPLAIN', 'FAIL', 'FOR', 'FOREIGN', 'FROM', 'FULL', 'GLOB', 'GROUP', 'HAVING', 'IF', 'IGNORE', 'IMMEDIATE', 'IN', 'INDEX', 'INDEXED', 'INITIALLY', 'INNER', 'INSERT', 'INSTEAD', 'INTERSECT', 'INTO', 'IS', 'ISNULL', 'JOIN', 'KEY', 'LEFT', 'LIKE', 'LIMIT', 'MATCH', 'NATURAL', 'NO', 'NOT', 'NOTNULL', 'NULL', 'OF', 'OFFSET', 'ON', 'OR', 'ORDER', 'OUTER', 'PLAN', 'PRAGMA', 'PRIMARY', 'QUERY', 'RAISE', 'REFERENCES', 'REGEXP', 'REINDEX', 'RELEASE', 'RENAME', 'REPLACE', 'RESTRICT', 'RIGHT', 'ROLLBACK', 'ROW', 'SAVEPOINT', 'SELECT', 'SET', 'TABLE', 'TEMP', 'TEMPORARY', 'THEN', 'TO', 'TRANSACTION', 'TRIGGER', 'UNION', 'UNIQUE', 'UPDATE', 'USING', 'VACUUM', 'VALUES', 'VIEW', 'VIRTUAL', 'WHEN', 'WHERE' ]

  let g:in_sql_mode = 1 - g:in_sql_mode
  for kw in l:sql_keywords
    let l:lower = tolower(kw)
    if g:in_sql_mode
      execute 'abbreviate ' . l:lower . ' ' . kw
    else
      execute 'unabbreviate ' . l:lower
    endif
  endfor

  if g:in_sql_mode
    echo 'Now in SQL mode'
  else
    echo 'No longer in SQL mode'
  endif
endfunction
map <Leader>ss :call ToggleSQLMode()<CR>

" templates
autocmd BufNewFile *.html call InsertTemplate('html')
autocmd BufNewFile *.tt2 call InsertTemplate('html')
autocmd BufNewFile *.xml call InsertTemplate('xml')
autocmd BufNewFile dist.ini call InsertTemplate('dist-zilla')
autocmd BufNewFile PKGBUILD call InsertTemplate('PKGBUILD')

nmap <leader>vm :call ViewModule(expand("<cword>"))<CR>

function MapToggle(key, opt)
   let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
   exec 'nnoremap '.a:key.' '.cmd
   exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)

MapToggle <F5> hlsearch
MapToggle <F6> list
MapToggle <F7> paste
MapToggle <F8> ignorecase
MapToggle <F9> number
MapToggle <F10> spell
MapToggle <F11> wrapscan

augroup HelpInTabs
  au!
  au BufEnter *.txt call HelpInNewTab()

  function HelpInNewTab()
    if &buftype == 'help'
      execute "normal \<C-W>T"
    endif
  endfunction
augroup END

function NoOp()
endfunction

abbrev ddc use Data::Dumper::Concise;
inoremap <C-A> <C-O> call NoOp()<CR>
nnoremap zo zO

inoremap <Leader>ll <ESC>:call InsertLog()<CR>

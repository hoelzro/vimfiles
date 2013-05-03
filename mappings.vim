noremap <C-p> :tabprev<CR>
noremap <C-n> :tabnext<CR>
noremap gf <C-w>gf

if exists(':TlistToggle')
  noremap <F2> :TlistToggle<CR>
endif
noremap <Leader>f $zf%

noremap <Leader>i :call InsertHeader()<CR>
noremap <Leader>tt :call RotateKeywords()<CR>
noremap <Leader>ss :call ToggleSQLMode()<CR>

" custom abbrevations for Perl modules I use a lot
function! LeaderAbbreviate(lhs, rhs)
  let code = "inoremap <Leader>" . a:lhs . " " . a:rhs
  execute l:code
endfunction

let ddc_installed = system("perl -e '$ok = eval { require Data::Dumper::Concise }; print($ok ? 1 : 0);'")

if ddc_installed
  call LeaderAbbreviate('uddc', 'use Data::Dumper::Concise;')
else
  call LeaderAbbreviate('uddc', 'use Data::Dumper;')
endif

call LeaderAbbreviate('uddp', 'use Data::Printer;')
call LeaderAbbreviate('utm',  'use Test::More;')

let perl_version       = system("perl -e 'print $]'")
let perl_version       = substitute(perl_version, '^5[.]', '', '')
let perl_major_version = substitute(matchstr(perl_version, '...'), '^0*', '', '')

if perl_major_version >= 10
  call LeaderAbbreviate('ufs',  'use feature qw(say);')
else
  call LeaderAbbreviate('ufs',  'use Perl6::Say;')
end

inoremap <C-A> <nop>
inoremap <C-@> <nop>
inoremap <Esc> <nop>
inoremap <C-c> <Esc>
nnoremap zo zO

" Make Y behave like other capitals
noremap Y y$

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cabbrev q1 q!
cabbrev ssu sus
cnoreabbrev su sus

vnoremap <Leader>= :Tabularize assignment<CR>

nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

nnoremap <C-x>n :set number!<CR>
nnoremap <C-x>l :set list!<CR>
nnoremap <C-x>s :set spell!<CR>
nnoremap <C-x>i :set ignorecase!<CR>
nnoremap <C-x>p :set paste<CR>
nnoremap <C-x><C-x> <C-x>

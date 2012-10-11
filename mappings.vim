noremap <C-p> :tabprev<CR>
noremap <C-n> :tabnext<CR>
noremap gf <C-w>gf
noremap <C-c> :tabnew<CR>

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

inoremap <C-A> <C-O> call NoOp()<CR>
inoremap <C-@> <C-O> call NoOp()<CR>
nnoremap zo zO

" Make Y behave like other capitals
noremap Y y$

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cabbrev q1 q!
cabbrev ssu sus

vnoremap <Leader>= :Tabularize assignment<CR>

nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

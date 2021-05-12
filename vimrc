" vim: sts=2 sw=2

if has('perl')

    perl <<PERL
use File::Spec;

@INC = map { File::Spec->rel2abs($_) } @INC;
PERL

endif

let old_verbose=&verbose
let old_verbosefile=&verbosefile
let old_runtimepath=&runtimepath
let old_filetype=&filetype
let old_lines=&lines
let old_columns=&columns
set all&
let &verbose=old_verbose
let &verbosefile=old_verbosefile
let &runtimepath=old_runtimepath
let &filetype=old_filetype
let &lines=old_lines
let &columns=old_columns
unlet old_verbose
unlet old_verbosefile
unlet old_runtimepath
unlet old_lines
unlet old_columns

"call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

packadd matchit

source ~/.vim/settings.vim
source ~/.vim/plugin-settings.vim
source ~/.vim/language-settings.vim
source ~/.vim/helper-functions.vim
source ~/.vim/mappings.vim
source ~/.vim/autocommands.vim

" Define a highlight group for things that annoy me
highlight Annoyance ctermbg=236
" I hate end of line whitespace...highlight it
match Annoyance /\s\+$/

" Fix the underlining for CursorLineNr that was introduced in 8.1.2029
highlight CursorLineNr cterm=bold ctermfg=11 gui=bold guifg=Yellow

" up arrow (↑)
digraph -^ 8593
" combining acute accent
digraph '' 769

try
  source ~/.vim/local.vim
catch /Vim\%((\a\+)\)\=:E484/ " catch 'could not find local.vim'
  " ignore it
endtry

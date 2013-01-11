" vim: sts=2 sw=2

if has('perl')

    perl <<PERL
use File::Spec;

@INC = map { File::Spec->rel2abs($_) } @INC;
PERL

endif

call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

source ~/.vim/settings.vim
source ~/.vim/plugin-settings.vim
source ~/.vim/language-settings.vim
source ~/.vim/helper-functions.vim
source ~/.vim/mappings.vim
source ~/.vim/autocommands.vim

" I hate end of line whitespace...highlight it
match Search /\s\+$/

" up arrow (↑)
digraph -^ 8593
" combining acute accent
digraph '' 769

try
  source ~/.vim/local.vim
catch /Vim\%((\a\+)\)\=:E484/ " catch 'could not find local.vim'
  " ignore it
endtry

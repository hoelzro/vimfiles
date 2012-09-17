let g:Perl_Support_Root_Dir = $HOME . '/.vim/bundle/perl-support'

" perl helper program
let perlhelp_prog = "mcpandoc"
if !executable(perlhelp_prog)
  unlet perlhelp_prog
endif

let g:ackprg       = expand('~/bin/ack -H --nocolor --nogroup')
let g:ackhighlight = 1

let g:ctrlp_map = '<c-o>'
let g:ctrlp_working_path_mode = 2

" NERD tree settings
let NERDTreeShowBookmarks   = 1
let NERDTreeShowLineNumbers = 1

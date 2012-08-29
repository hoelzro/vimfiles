let g:Perl_Support_Root_Dir = $HOME . '/.vim/bundle/perl-support'

" perl helper program
let perlhelp_prog = "mcpandoc"
if !executable(perlhelp_prog)
  unlet perlhelp_prog
endif

" templates
autocmd BufNewFile *.html call InsertTemplate('html')
autocmd BufNewFile *.tt2 call InsertTemplate('html')
autocmd BufNewFile *.xml call InsertTemplate('xml')
autocmd BufNewFile dist.ini call InsertTemplate('dist-zilla')
autocmd BufNewFile PKGBUILD call InsertTemplate('PKGBUILD')

let g:ctrlp_map = '<c-o>'
let g:ctrlp_working_path_mode = 2

" NERD tree settings
let NERDTreeShowBookmarks   = 1
let NERDTreeShowLineNumbers = 1

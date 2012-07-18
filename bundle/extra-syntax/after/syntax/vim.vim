let s:bcs = b:current_syntax
unlet b:current_syntax
syntax include @Perl syntax/perl.vim
let b:current_syntax = s:bcs
syntax region vimHereDocPerl matchgroup=Statement start=+perl\s*<<\s*\z(.*\)+ end=+^\z1+ contains=@Perl

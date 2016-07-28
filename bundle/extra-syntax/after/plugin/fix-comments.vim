function! s:FixComments()
  if &filetype == 'perl' || &filetype == 'perl6' || &filetype == 'python' || &filetype == 'ruby'
    let &l:comments='sl:# XXX,mb:#,e:^@,b:#,fb:-'
  endif
endfunction

"setlocal comments=sl:#\ XXX,mb:#,e:^@,b:#,fb:-
au FileType * call <SID>FixComments()

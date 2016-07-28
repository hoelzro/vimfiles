function! s:FixComments()
  if &filetype == 'perl' || &filetype == 'perl6' || &filetype == 'python' || &filetype == 'ruby'
    let &l:comments='sl:# XXX,mb:#,e:^@,b:#,fb:-'
  endif
endfunction

au FileType * call <SID>FixComments()

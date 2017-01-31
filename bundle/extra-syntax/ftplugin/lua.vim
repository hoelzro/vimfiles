setlocal softtabstop=2
setlocal shiftwidth=2
runtime indent/lua.vim

function! s:RunEqualsOperator(op)
  let current_line = getline('.')
  let lhs_expr = substitute(current_line, '^\s\+\|\s\+$', '', 'g')
  return '= ' . lhs_expr . ' ' . a:op . ' '
endfunction

inoremap <buffer> <silent> <expr> +=  <SID>RunEqualsOperator('+')
inoremap <buffer> <silent> <expr> -=  <SID>RunEqualsOperator('-')
inoremap <buffer> <silent> <expr> *=  <SID>RunEqualsOperator('*')
inoremap <buffer> <silent> <expr> /=  <SID>RunEqualsOperator('/')
inoremap <buffer> <silent> <expr> ..= <SID>RunEqualsOperator('..')

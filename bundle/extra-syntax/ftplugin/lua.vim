setlocal softtabstop=2
setlocal shiftwidth=2
runtime indent/lua.vim

function! s:RunEqualsOperator()
  let current_line = getline('.')
  let m = matchlist(current_line, '^\s*\([a-zA-Z0-9_.]\+\)\s*\([-+*/]\|\.\.\)')
  if empty(m)
    return '='
  endif

  let [lhs_expr, operator] = m[1:2]

  return repeat('', strlen(operator)) . '= ' . lhs_expr . ' ' . operator . ' '
endfunction

imapclear <buffer>

inoremap <buffer> <silent> <expr> = <SID>RunEqualsOperator()

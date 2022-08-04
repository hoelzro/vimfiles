setlocal softtabstop=2
setlocal shiftwidth=2
runtime indent/lua.vim

function! s:RunEqualsOperator()
  let current_line = getline('.')
  let rhs_expr = ''
  let m = matchlist(current_line, '^\s*\([a-zA-Z0-9_.]\+\[[a-zA-Z0-9_.]\+\]\)\s*\([-+*/]\|\.\.\)')
  if !empty(m)
    let [lhs_expr, operator] = m[1:2]
    if operator == '..'
      let rhs_expr = '(' . lhs_expr . " or '')"
    else
      let rhs_expr = '(' . lhs_expr . ' or 0)'
    end
  endif

  let m = matchlist(current_line, '^\s*\([a-zA-Z0-9_.]\+\)\s*\([-+*/]\|\.\.\)')
  if !empty(m)
    let [lhs_expr, operator] = m[1:2]
    let rhs_expr = lhs_expr
  endif

  if rhs_expr == ''
    return '='
  endif

  return repeat('', strlen(operator)) . '= ' . rhs_expr . ' ' . operator . ' '
endfunction

imapclear <buffer>

inoremap <buffer> <silent> <expr> = <SID>RunEqualsOperator()

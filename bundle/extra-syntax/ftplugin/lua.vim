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

function! s:RunIncrDecrOperator(op)
  let current_line = getline('.')
  let m = matchlist(current_line, '^\s*\([a-zA-Z0-9_.]\+\[[a-zA-Z0-9_.]\+\]\)\([+-]\)')
  let rhs_expr = ''
  if !empty(m)
    let [lhs_expr, operator] = m[1:2]
    let rhs_expr = '(' . lhs_expr . ' or 0)'
  endif

  let m = matchlist(current_line, '^\s*\([a-zA-Z0-9_.]\+\)\([+-]\)')
  if !empty(m)
    let [lhs_expr, operator] = m[1:2]
    let rhs_expr = lhs_expr
  endif

  if rhs_expr == ''
    return a:op
  endif

  if a:op != operator
    return a:op
  endif

  return '' . ' = ' . rhs_expr . ' ' . a:op . ' 1'
endfunction

imapclear <buffer>

inoremap <buffer> <silent> <expr> = <SID>RunEqualsOperator()
inoremap <buffer> <silent> <expr> + <SID>RunIncrDecrOperator('+')
inoremap <buffer> <silent> <expr> - <SID>RunIncrDecrOperator('-')

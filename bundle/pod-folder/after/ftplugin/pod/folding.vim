" POD folding script
" Author: Rob Hoelz <rob 'at' hoelz.ro>

" Thanks to Drew Neil for his overview on expr-based folding,
" which made writing this plugin possible!

function! PodFolds()
  let line       = getline(v:lnum)
  let submatches = matchlist(line, '^=head\(\d\)')

  if empty(submatches)
    return '='
  endif

  return '>' . submatches[1]
endfunction

setlocal foldmethod=expr
setlocal foldexpr=PodFolds()

" vim:sts=2 sw=2

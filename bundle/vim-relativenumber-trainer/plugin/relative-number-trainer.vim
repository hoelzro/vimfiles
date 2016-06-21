if get(g:, 'relativenumbertrainer_loaded')
  finish
endif

let g:relativenumbertrainer_loaded = 1

function! PerformRelativeLineNumberHeurstic(cmd)
  if !&relativenumber || v:count == 0
    return a:cmd
  endif
  " XXX wrapping screws up the range check, but it's close enough
  let lines_above = winline() - 1
  let lines_below = winheight(winnr()) - winline()

  let cmd = a:cmd

  if v:count < lines_above " if ambiguous, assume I mean the line above
    let cmd = 'k'
  elseif v:count < lines_below
    let cmd = 'j'
  end " otherwise, just jump to the line

  if cmd != a:cmd
    echohl WarningMsg
    echo 'You meant "' . v:count . cmd . '"'
    echohl None
    sleep 1
  endif

  return cmd
endfunction

nnoremap <expr> <silent> gg PerformRelativeLineNumberHeurstic('gg')
nnoremap <expr> <silent> G PerformRelativeLineNumberHeurstic('G')

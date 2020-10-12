" Subscribe to events via `autocmd User $EVENT $CODE`
" Events published by this plugin:
"
"   - SearchNew - When you conduct a new search.  The cursor has already moved, the search string is in getreg('/'), v:searchforward is set properly, and b:search_operator is set to '/', '*', '#', etc
"   - SearchNextPre - Before you move to the next search result (in the direction of v:searchforward)
"   - SearchNextPost - After you move to the next search result (in the direction of v:searchforward)
"   - SearchPrevPre - Before you move to the previous search result (opposite the direction of v:searchforward)
"   - SearchPrevPost - After you move to the previous search result (opposite the direction of v:searchforward)

function! s:PostEnter(cmd_type)
  let b:search_operator = a:cmd_type
  doautocmd <nomodeline> User SearchNew
endfunction

function! s:HandleEnter()
  let cmd_type = getcmdtype()

  let post_enter_fn = substitute(substitute(expand('<sfile>'), 'HandleEnter$', 'PostEnter', ''), 'function\s\+', '', '')
  if cmd_type == '/' || cmd_type == '?'
    " XXX if there are no results, PostEnter doesn't get called =/
    return printf("\<CR>:call %s('%s')\<CR>", post_enter_fn, cmd_type)
  endif
  " XXX dispatch other events
  return "\<CR>"
endfunction

function! s:HandleStar()
  let post_enter_fn = substitute(substitute(expand('<sfile>'), 'HandleStar$', 'PostEnter', ''), 'function\s\+', '', '')
  return printf("*:call %s('*')\<CR>", post_enter_fn)
endfunction

function! s:HandlePound()
  let post_enter_fn = substitute(substitute(expand('<sfile>'), 'HandlePound$', 'PostEnter', ''), 'function\s\+', '', '')
  return printf("#:call %s('#')\<CR>", post_enter_fn)
endfunction

function! s:HandleLowerN()
  doautocmd <nomodeline> User SearchNextPre
  normal! n
  doautocmd <nomodeline> User SearchNextPost
endfunction

function! s:HandleUpperN()
  doautocmd <nomodeline> User SearchNextPre
  normal! N
  doautocmd <nomodeline> User SearchNextPost
endfunction

cnoremap <silent> <expr> <Enter> <SID>HandleEnter()
nnoremap <silent> <expr> * <SID>HandleStar()
nnoremap <silent> <expr> # <SID>HandlePound()
nnoremap <silent> n :call <SID>HandleLowerN()<CR>
nnoremap <silent> N :call <SID>HandleUpperN()<CR>

function! s:NoOp()
endfunction

augroup SearchDummies
  autocmd User SearchNew call <SID>NoOp()
  autocmd User SearchNextPre call <SID>NoOp()
  autocmd User SearchNextPost call <SID>NoOp()
  autocmd User SearchPrevPre call <SID>NoOp()
  autocmd User SearchPrevPost call <SID>NoOp()
augroup END

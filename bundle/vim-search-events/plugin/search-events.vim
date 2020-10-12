" Subscribe to events via `autocmd User $EVENT $CODE`
" Events published by this plugin:
"
"   - SearchNew - When you conduct a new search.  The cursor has already moved, the search string is in getreg('/'), v:searchforward is set properly, and b:search_operator is set to '/', '*', '#', etc
"   - SearchNextPre - Before you move to the next search result (in the direction of v:searchforward)
"   - SearchNextPost - After you move to the next search result (in the direction of v:searchforward)
"   - SearchPrevPre - Before you move to the previous search result (opposite the direction of v:searchforward)
"   - SearchPrevPost - After you move to the previous search result (opposite the direction of v:searchforward)

function! PostEnter(cmd_type)
  let b:search_operator = a:cmd_type
  doautocmd <nomodeline> User SearchNew
endfunction

function! HandleEnter()
  let cmd_type = getcmdtype()

  if cmd_type == '/' || cmd_type == '?'
    " XXX if there are no results, PostEnter doesn't get called =/
    return "\<CR>:call PostEnter('" . cmd_type . "')\<CR>"
  endif
  " XXX dispatch other events
  return "\<CR>"
endfunction

function! HandleStar()
  return "*:call PostEnter('*')\<CR>"
endfunction

function! HandlePound()
  return "#:call PostEnter('#')\<CR>"
endfunction

function! HandleLowerN()
  doautocmd <nomodeline> User SearchNextPre
  normal! n
  doautocmd <nomodeline> User SearchNextPost
endfunction

function! HandleUpperN()
  doautocmd <nomodeline> User SearchNextPre
  normal! N
  doautocmd <nomodeline> User SearchNextPost
endfunction

cnoremap <silent> <expr> <Enter> HandleEnter()
nnoremap <silent> <expr> * HandleStar()
nnoremap <silent> <expr> # HandlePound()
nnoremap <silent> n :call HandleLowerN()<CR>
nnoremap <silent> N :call HandleUpperN()<CR>

function! NoOp()
endfunction

augroup SearchDummies
  autocmd User SearchNew call NoOp()
  autocmd User SearchNextPre call NoOp()
  autocmd User SearchNextPost call NoOp()
  autocmd User SearchPrevPre call NoOp()
  autocmd User SearchPrevPost call NoOp()
augroup END

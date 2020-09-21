function! WrapScalion(new_search, key)
  if a:new_search
    " Vim has already moved the cursor, so this data
    " here ↓ is the first match of the search
    let [buf_no, line, column, offset] = getpos('.')
    " XXX what happens if there are no results in the search direction?
    "     what happens if there are no results in the file *at all*?
    call prop_remove({'type': 'search_start'})
    call prop_add(line, column, {'type': 'search_start'})
  else " XXX split into two functions
    let search_string = getreg('/')
    let search_flags = 'nw' " do (n)ot move the cursor & (w)rap around the end of the file
    if v:searchforward == 0
      let search_flags = 'b' .. search_flags
    endif

    let [next_match_line, next_match_col] = searchpos(search_string, search_flags)

    let search_start_location = prop_find({'type': 'search_start'})

    if empty(search_start_location)
      let search_start_location = prop_find({'type': 'search_start'}, 'b')
    endif

    if empty(search_start_location)
      " XXX panic!
    endif

    let search_start_line = search_start_location['lnum']
    let search_start_col = search_start_location['col']

    " if the next match is where we started, we're wrapping, so do a thing
    if next_match_line == search_start_line && next_match_col == search_start_col
      " XXX other choices - next buffer, next tab, next window, etc
      let choice = input("You've wrapped around to where you started your search - what would you like to do? (w)rap ")
      if choice == 'w'
        execute 'normal! ' . a:key
      endif
    else
      execute 'normal! ' . a:key
    endif
    " XXX invoke other things like vim-bling if we moved
  endif
endfunction

function! WrapScalionExpr()
  let cmd_type = getcmdtype()
  if cmd_type == '/' || cmd_type == '?'
    return "\<CR>:call WrapScalion(1, '')\<CR>"
  endif
  return "\<CR>"
endfunction

try
  call prop_type_add('search_start', {})
catch /^Vim\%((\a\+)\)\=:E969:/
catch /^Vim\%((\a\+)\)\=:E970:/
endtry

" XXX wrapscan *must* be on for this to work
nnoremap <silent> n :call WrapScalion(0, 'n')<CR>
nnoremap <silent> N :call WrapScalion(0, 'N')<CR>
cnoremap <silent> <expr> <enter> WrapScalionExpr()

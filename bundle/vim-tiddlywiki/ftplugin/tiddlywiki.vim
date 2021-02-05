" Vim filetype plugin for TiddlyWiki
" Language: tiddlywiki
" Maintainer: Devin Weaver <suki@tritarget.org>
" License: http://www.apache.org/licenses/LICENSE-2.0.txt

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo-=C

function! TiddlyWikiTime()
  return system("date -u +'%Y%m%d%H%M%S'")[:-2] . "000"
endfunction

function! s:UpdateModifiedTime()
  let save_cursor = getcurpos()
  silent 0,/^\s*$/global/^modified: / delete
  call append(0, "modified: " . TiddlyWikiTime())
  call setpos('.', save_cursor)
endfunction

function! s:AutoUpdateModifiedTime()
  if &modified
    call <SID>UpdateModifiedTime()
  endif
endfunction

function! s:InitializeTemplate()
  let timestamp = TiddlyWikiTime()
  call append(0, "modified: " . timestamp)
  call append(1, "created: " . timestamp)
  call append(2, "modifier: ")
  call append(3, "creator: ")
  call append(4, "title: ")
  call append(5, "tags: ")
  call append(6, "")
endfunction

function! TiddlyWikiFold()
  let line = getline(v:lnum)

  let i = 1
  let buffer_lines = line('$')
  let last_field_line_number = 0
  while i < buffer_lines
    let field_line = getline(i)
    if field_line == ''
      break
    endif
    let last_field_line_number = i
    let i += 1
  endwhile

  " Tiddler fields are all in their own fold
  " XXX nice fold text
  if v:lnum <= last_field_line_number
    return 1
  endif

  " Match headings and set level accordingly
  let m = matchlist(line, '^!\+')
  if !empty(m)
    return '>' . len(m[0])
  endif

  " Don't include trailing blank lines in previous fold
  if nextnonblank(v:lnum) > v:lnum
    return -1
  endif

  return '='
endfunction

setlocal foldexpr=TiddlyWikiFold()
setlocal foldmethod=expr

if exists("g:tiddlywiki_autoupdate")
  augroup tiddlywiki
    au BufWrite, *.tid call <SID>AutoUpdateModifiedTime()
  augroup END
endif

if !exists("g:tiddlywiki_no_mappings")
  nmap <Leader>tm :call <SID>UpdateModifiedTime()<Cr>
  nmap <Leader>tt :call <SID>InitializeTemplate()<Cr>
endif

let &cpo = s:save_cpo

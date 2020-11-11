" XXX when you read, get the underlying tiddler itself (what if there's an open draft already?)
" XXX when do we write the non-draft tiddler?
" XXX HTTPS option?

function! s:URLEncode(s)
  return substitute(a:s, '\([^-a-zA-Z0-9_.~]\)', '\=printf("%%%X", char2nr(submatch(1)))', 'g')
endfunction

function! s:GetTimezoneOffset()
  let offset = strftime('%z')
  let m = matchlist(offset, '^\([-+]\=\)\(\d\d\)\(\d\d\)')

  return (m[1] == '-' ? -1 : 1) * (str2nr(m[2]) * 60 * 60) + (str2nr(m[3]) * 60)
endfunction

function! s:ReadTiddler(url)
  set filetype=tiddlywiki

  let m = matchlist(a:url, '^tw://\([^/]\+\)/\(.*\)')
  let wiki_domain = m[1]
  let tiddler_title = <SID>URLEncode(m[2])

  let tz_offset = <SID>GetTimezoneOffset()

  let url = 'http://' . wiki_domain . '/recipes/default/tiddlers/' . tiddler_title
  let tiddler_text = system("curl -s " . shellescape(url)) " XXX handle errors
  if tiddler_text == ''
    let creation_time = strftime('%Y%m%d%H%M%S000', localtime() - tz_offset)
    call setline(1, 'title: ' . "Draft of '" . m[2] . "'")
    call setline(2, 'draft.of: ' . m[2])
    call setline(3, 'draft.title: ' . m[2])
    call setline(4, 'type: text/vnd.tiddlywiki')
    call setline(5, 'created: ' . creation_time)
    call setline(6, 'modified: ' . creation_time)
    call setline(7, '')
    let b:has_draft = 1
    return
  endif
  let json = json_decode(tiddler_text) " XXX handle errors
  let line_no = 1
  " XXX store these for the save?
  call remove(json, 'bag')
  call remove(json, 'revision')
  let text = remove(json, 'text')
  for k in sort(keys(json))
    let v = json[k]
    call setline(line_no, k . ': ' . v)
    let line_no += 1
  endfor
  call append(line('$'), '')
  call append(line('$'), split(text, '\n'))
endfunction

function! s:WriteTiddler(url)
  if !&modified
    return
  endif

  if !get(b:, 'has_draft', 0)
    let b:has_draft = 1

    let curr_line = 1
    let last_line = line('$')
    let title = ''

    while curr_line <= last_line
      let line = getline(curr_line)

      let m = matchlist(line, '^\s*title:\s*\(.*\)')

      if !empty(m)
        let title = m[1]
        call setline(curr_line, 'title: ' . "Draft of '" . title . "'")
      elseif match(line, '^\s*$') != -1
        if title != ''
          call append(curr_line-1, 'draft.of: ' . title)
          call append(curr_line-1, 'draft.title: ' . title)
        endif
        break
      endif

      let curr_line += 1
    endwhile
  endif

  let tz_offset = <SID>GetTimezoneOffset()

  let curr_line = 1
  let last_line = line('$')
  " XXX bring bag and revision back?
  let fields = {}
  while curr_line <= last_line
    let line = getline(curr_line)

    if match(line, '^\s*modified:') != -1
      let line = 'modified: ' . strftime('%Y%m%d%H%M%S000', localtime() - tz_offset)
      call setline(curr_line, line)
    elseif match(line, '^\s*$') != -1
      break
    endif

    let m = matchlist(line, '^\s*\([^:]\+\):\s*\(.*\)')
    if !empty(m)
      let fields[m[1]] = m[2]
    endif

    let curr_line += 1
  endwhile

  let curr_line = nextnonblank(curr_line)

  let fields['text'] = join(getline(curr_line, last_line), "\n")

  let payload = json_encode(fields)

  let payload_file = tempname()
  call writefile([payload], payload_file)

  set nomodified

  let m = matchlist(a:url, '^tw://\([^/]\+\)/\(.*\)')
  let wiki_domain = m[1]
  let tiddler_title = m[2]
  let tiddler_title = "Draft of '" . tiddler_title . "'"

  let url = 'http://' . wiki_domain . '/recipes/default/tiddlers/' . <SID>URLEncode(tiddler_title)
  " XXX handle errors
  let output = system('curl -s -X PUT -H "X-Requested-With: TiddlyWiki" -d ' . shellescape('@' . payload_file) . ' ' . shellescape(url))

  call delete(payload_file)
endfunction

function! s:FlushTiddlers()
  for buf in getbufinfo()
    if match(buf.name, '^tw://') == -1
      continue
    endif

    if !get(buf.variables, 'has_draft', 0)
      continue
    endif

    " XXX "move" draft to actual title
    " XXX delete draft
  endfor
endfunction

augroup TiddlyWikiNetRW
  autocmd!

  autocmd BufReadCmd tw://* call <SID>ReadTiddler(expand('<amatch>'))
  autocmd BufWriteCmd tw://* call <SID>WriteTiddler(expand('<amatch>'))

  " XXX is this the best way to flush the draft?
  autocmd VimLeavePre * call <SID>FlushTiddlers()
augroup END

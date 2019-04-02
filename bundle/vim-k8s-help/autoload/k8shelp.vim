let s:helper_script = expand('<sfile>:p:h:h') . '/kyaml-path.pl'

function! s:GetAPIVersion(filename)
  let buffer = bufnr(a:filename)

  if buffer == -1
    throw "Couldn't find buffer for " . a:filename
  endif

  let buffer_lines = getbufline(buffer, 1, '$')
  let line_no = 1

  for line in buffer_lines
    let matches = matchlist(line, '^\s*apiVersion\s*:\s*\(\S\+\)')

    if !empty(matches)
      return matches[1]
    endif

    let line_no += 1
  endfor

  throw 'Unable to find apiVersion'
endfunction

function! s:GetObjectKind(filename)
  let buffer = bufnr(a:filename)

  if buffer == -1
    throw "Couldn't find buffer for " . a:filename
  endif

  let buffer_lines = getbufline(buffer, 1, '$')
  let line_no = 1

  for line in buffer_lines
    let matches = matchlist(line, '^\s*kind\s*:\s*\(\S\+\)')

    if !empty(matches)
      return matches[1]
    endif

    let line_no += 1
  endfor

  throw 'Unable to find kind'
endfunction

function! s:GetYAMLPath(filename, line, column)
  " XXX handle ---
  "     handle the List kind
  let current_line = getline(a:line)
  let matches = matchlist(current_line, '^\(\s*\%(-\s*\)\?\)\(\i*\%' . a:column . 'c\i\+\)')
  if len(matches) == 0
    return
  endif
  let current_indent = len(matches[1])
  let ident_user_cursor = matches[2]
  let path_components = [ident_user_cursor]

  for line_no in range(a:line - 1, 1, -1)
    let preceding_line = getline(line_no)
    if preceding_line =~ '^\s*$'
      continue
    endif

    let matches = matchlist(preceding_line, '^\(\s*\%(-\s*\)\?\)\(\i*\)')
    let indent = len(matches[1])
    let key = matches[2]

    if indent < current_indent
      call add(path_components, key)
      let current_indent = indent
    endif
  endfor

  return join(reverse(path_components), '.')
endfunction

function! k8shelp#KubernetesHelp()
  let [_, line_no, column, _] = getpos('.')
  let object_path = <SID>GetYAMLPath(expand('%'), line_no, column)
  let api_version = <SID>GetAPIVersion(expand('%'))
  let object_kind = <SID>GetObjectKind(expand('%'))
  let full_path = tolower(object_kind) . '.' . object_path

  new

  execute 'r! kubectl --api-version=' . api_version . ' explain ' . full_path
  normal gg
  normal dd

  setlocal nomodified
  setlocal nomodifiable
  setlocal hidden
  setlocal noswapfile
endfunction

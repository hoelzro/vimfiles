let s:helper_script = expand('<sfile>:p:h:h') . '/kyaml-path.pl'

function! s:GetAPIVersion(filename)
  let buffer = bufnr(a:filename)

  if buffer == -1
    throw "Couldn't find buffer for " . a:filename
  endif

  let current_buffer = bufnr('.')

  if buffer != current_buffer
    throw 'Slow path of getting API version from non-current buffer NYI'
  endif

  let [_, lnum, col, off] = getpos('.')

  " start the search at the beginning of the file
  call cursor(1, 1, 0)

  let api_version_line_no = search('^\s*apiVersion\s*:', 'n')

  let api_version_line = getline(api_version_line_no)

  " restore the cursor to where it was pre-search
  call cursor(lnum, col, off)

  let api_version = matchlist(api_version_line, '^\s*apiVersion\s*:\s*\(\S\+\)')[1]

  return api_version
endfunction

function! s:GetObjectKind(filename)
  return 'Pod'
endfunction

function! s:GetYAMLPath(filename, line, column)
  return systemlist(s:helper_script . ' ' . a:line . ' ' . a:column . ' ' . shellescape(a:filename))[0]
endfunction

function! k8shelp#KubernetesHelp()
  let [_, line_no, column, _] = getpos('.')
  let object_path = <SID>GetYAMLPath(expand('%'), line_no, column)
  let api_version = <SID>GetAPIVersion(expand('%'))
  let object_kind = <SID>GetObjectKind(expand('%'))
  let full_path = tolower(object_kind) . '.' . object_path

  execute '!kubectl --api-version=' . api_version . ' explain ' . full_path
endfunction

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

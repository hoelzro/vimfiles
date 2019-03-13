let s:helper_script = expand('<sfile>:p:h:h') . '/kyaml-path.pl'

function! s:GetAPIVersion(filename)
  return 'v1'
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
  echomsg full_path
endfunction

let s:helper_script = expand('<sfile>:p:h:h') . '/kyaml-path.pl'

function! s:GetYAMLPath(filename, line, column)
  return systemlist(s:helper_script . ' ' . a:line . ' ' . a:column . ' ' . shellescape(a:filename))[0]
endfunction

function! k8shelp#KubernetesHelp()
  let [_, line_no, column, _] = getpos('.')
  let object_path = <SID>GetYAMLPath(expand('%'), line_no, column)
  echomsg object_path
endfunction

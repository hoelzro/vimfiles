function s:FindGitRoot(path)
  let path = system('cd ' . shellescape(a:path) . '; git rev-parse --show-toplevel 2>/dev/null')

  if v:shell_error != 0
    let path = ''
  else
    let path = substitute(path, '\n$', '', '')
  endif

  return path
endfunction

function! NERDTreeGoToProjectRoot()
  let root_path = b:NERDTreeRoot.path.str()
  let git_root  = <SID>FindGitRoot(root_path)

  if empty(git_root)
    echo 'Could not find project root'
    return
  endif

  let new_root = g:NERDTreeFileNode.New(g:NERDTreePath.New(git_root))
  call new_root.makeRoot()
  call NERDTreeRender()
endfunction

call NERDTreeAddKeyMap({
  \ 'key'           : 'R',
  \ 'callback'      : 'NERDTreeGoToProjectRoot',
  \ 'quickhelpText' : 'Go to the project''s root' })

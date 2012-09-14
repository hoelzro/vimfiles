function NERDTreeOpenAllFilesInBuffers()
  let dir         = g:NERDTreeDirNode.GetSelected()
  let index       = 0
  let child_count = dir.getChildCount()
  let children    = dir.getVisibleChildren()
  let bufno       = bufnr('$') + 1

  for child in children
    if child.path.isDirectory ==# 0
      execute "badd " . fnameescape(child.path.str())
    endif
  endfor

  execute "buffer " . bufno
endfunction

call NERDTreeAddMenuItem({
  \ 'text'     : '(o)pen all files in buffers',
  \ 'shortcut' : 'o',
  \ 'callback' : 'NERDTreeOpenAllFilesInBuffers' })

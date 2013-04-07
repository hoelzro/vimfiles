function! InsertHeader()
  if !exists('b:comment_char')
    let b:comment_char = input("What's the comment character for the language in which you're working? ")
  endif

  let text = input('Header: ')
  let len = strlen(text)

  let len = len + 2
  let padding = repeat(b:comment_char, (80 - len) / 2)
  let text = padding . ' ' . text . ' ' . padding
  if len % 2 != 0
    let text = text . b:comment_char
  endif

  call append(line('.') - 1, text)
endfunction

function! s:IsActuallyDirty(path)
  let status_output = system('cd ' . shellescape(a:path) . '; git status --porcelain')
  return len(status_output) != 0
endfunction

function! s:IsRebasing(path)
  let file = a:path . '/.git/rebase-apply'

  return filereadable(file)
endfunction

function! FlushVimWiki()
  if !exists('g:dirty_wikis')
    return
  endif

  for wiki in values(g:dirty_wikis)
    if !<SID>IsActuallyDirty(wiki.path)
      continue
    endif

    if <SID>IsRebasing(wiki.path)
      continue
    endif

    echo 'pushing changes for ' . wiki.path
    call system('cd ' . shellescape(wiki.path) . '; git add --all .; git commit -m update; git push')

    if v:shell_error != 0
      call input('An error occurred when pushing changes! (please enter to exit Vim) ')
    endif
  endfor
endfunction

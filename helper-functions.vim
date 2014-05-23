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
    let path = expand(wiki.path)
    if !<SID>IsActuallyDirty(path)
      continue
    endif

    if <SID>IsRebasing(path)
      continue
    endif

    echo 'pushing changes for ' . path
    call system('cd ' . shellescape(path) . '; git add --all .; git commit -m update; git push')

    if v:shell_error != 0
      call input('An error occurred when pushing changes! (please enter to exit Vim) ')
    endif
  endfor
endfunction

" XXX override <CR> in window?
function! Page(command)
  " redirect command output to variable
  redir => paged_stuff
  silent execute a:command
  redir END

  " set up scratch window
  botright 10new
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modifiable
  execute 'file ' . a:command

  " set up custom commands
  nnoremap <buffer> <silent> q :q<CR>

  " inject output into window
  let lines = split(paged_stuff, '\n')
  call append(0, lines)
  normal Gdd " remove the last lien
endfunction

command! -nargs=+ -complete=command Page call Page(<q-args>)

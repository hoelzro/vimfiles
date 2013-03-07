augroup Custom
  autocmd!

  " Automatic saving and loading of views
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview

  " prevent saving to files that I'm probably writing on accident
  autocmd BufWritePre 1 throw 'Suspicious filename "1"'
  autocmd BufWritePre 2 throw 'Suspicious filename "2"'
  autocmd BufWritePre [\\] throw 'Suspicious filename "\"'
augroup END

" open help windows in their own tabs
augroup HelpInTabs
  au!
  au BufRead *.txt call <SID>HelpInNewTab()

  function! s:HelpInNewTab()
    if &buftype == 'help'
      execute "normal \<C-W>T"
      setlocal ignorecase
    endif
  endfunction
augroup END

function! s:HandleFileChange()
  if v:fcs_reason == 'mode'
    let v:fcs_choice = ''
  else
    let v:fcs_choice = 'ask'
  endif
endfunction

augroup Custom
  autocmd!

  autocmd InsertLeave * set nopaste
  autocmd VimResized * exe "normal! \<c-w>="
  autocmd BufWritePost *.pl silent !chmod 755 %
  autocmd FileChangedShell * call <SID>HandleFileChange()
augroup END

augroup VimWiki
  autocmd!

  function! s:IsPrefix(prefix, str)
    return a:str[0:len(a:prefix)-1] ==# a:prefix
  endfunction

  function! s:IsGitRepo(path)
    call system('cd ' . shellescape(a:path) . '; git status &>/dev/null')

    return !v:shell_error
  endfunction

  function! s:IsActuallyDirty(path)
    let status_output = system('cd ' . shellescape(a:path) . '; git status --porcelain')
    return len(status_output) != 0
  endfunction

  function! s:AddDirtyWikiFile()
    let path = expand('%:p')
    for wiki in g:vimwiki_list
      let wiki_path = expand(wiki.path)

      if <SID>IsPrefix(wiki_path, path)
        if !<SID>IsGitRepo(wiki_path)
          return
        endif

        if !exists('g:dirty_wikis')
          let g:dirty_wikis = {}
        endif

        let g:dirty_wikis[wiki_path] = wiki

        return
      endif
    endfor
  endfunction

  function! s:PushDirtyWikis()
    if !exists('g:dirty_wikis')
      return
    endif

    for wiki in values(g:dirty_wikis)
      if !<SID>IsActuallyDirty(wiki.path)
        continue
      endif

      echo 'pushing changes for ' . wiki.path
      call system('cd ' . shellescape(wiki.path) . '; git add --all .; git commit -m update; git push')
    endfor
  endfunction

  autocmd BufWritePost *.wiki call <SID>AddDirtyWikiFile()
  autocmd VimLeavePre  * call <SID>PushDirtyWikis()
augroup END

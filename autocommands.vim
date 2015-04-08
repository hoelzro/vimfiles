augroup Custom
  autocmd!

  " prevent saving to files that I'm probably writing on accident
  autocmd BufWritePre 1 throw 'Suspicious filename "1"'
  autocmd BufWritePre 2 throw 'Suspicious filename "2"'
  autocmd BufWritePre ' throw 'Suspicious filename "''"'
  autocmd BufWritePre [\\] throw 'Suspicious filename "\"'

  autocmd InsertLeave * set nopaste
  autocmd VimResized * exe "normal! \<c-w>="
  autocmd BufWritePost *.pl silent !chmod 755 %
  autocmd FileChangedShell * call <SID>HandleFileChange()

  autocmd InsertEnter * let b:old_fold=&foldmethod | set foldmethod=manual
  autocmd InsertLeave * let &foldmethod=b:old_fold

  " works in concert with some insert mappings in mappings.vim
  autocmd CompleteDone * let &l:ignorecase=b:oldignorecase | unlet b:oldignorecase
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

augroup VimWiki
  autocmd!

  function! s:IsPrefix(prefix, str)
    return a:str[0:len(a:prefix)-1] ==# a:prefix
  endfunction

  function! s:IsGitRepo(path)
    let file = a:path . '.git'

    return isdirectory(file)
  endfunction

  function! s:AddDirtyWikiFile()
    let path = expand('%:p')
    for wiki in g:vimwiki_list
      let wiki_path = expand(wiki.path)

      if <SID>IsPrefix(wiki_path, path)
        if !<SID>IsGitRepo(wiki_path)
          continue
        endif

        if !exists('g:dirty_wikis')
          let g:dirty_wikis = {}
        endif

        let g:dirty_wikis[wiki_path] = wiki

        return
      endif
    endfor
  endfunction

  autocmd BufWritePost *.wiki call <SID>AddDirtyWikiFile()
  autocmd VimLeavePre  * call FlushVimWiki()
augroup END

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
  autocmd InsertLeave * set nopaste
  autocmd VimResized * exe "normal! \<c-w>="
  autocmd BufWritePost *.pl silent !chmod 755 %
  autocmd FileChangedShell * call <SID>HandleFileChange()
augroup END

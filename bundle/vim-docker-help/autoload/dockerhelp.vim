let s:reference_dir = expand('<sfile>:p:h:h') . '/reference'

function! dockerhelp#DockerHelp(directive)
  " XXX check if s:reference_dir exists and initialize if not

  let help_file = s:reference_dir . '/' . tolower(a:directive) . '.txt'

  if !filereadable(help_file)
    echo '*** Sorry - no help for ' . a:directive . ' ***'
    return
  endif

  execute 'pedit ' . help_file

  wincmd P
  setlocal nomodifiable
  setlocal hidden
  setlocal noswapfile
  normal gg
endfunction

call AddKeywordType('Perl identifier', 'a-z,A-Z,48-57,_,:')

inoremap (<<' (<<'END_SQL');<CR><C-o>0END_SQL<C-o>O
inoremap (<<" (<<"END_SQL");<CR><C-o>0END_SQL<C-o>O
inoremap -. ->

let b:manpageview_sections = [2, 3, 4, 5, 7, 1, 8, 9, 6, 'n']

" copied from vim-perl, shame on me for the copy pasta
function! s:DetectPerl6()
  let line_no = 1
  let eof     = line('$')
  let in_pod  = 0

  while line_no <= eof
    let line    = getline(line_no)
    let line_no = line_no + 1

    if line =~ '^=\w'
      let in_pod = 1
    elseif line =~ '^=\%(end\|cut\)'
      let in_pod = 0
    elseif !in_pod
      let line = substitute(line, '#.*', '', '')

      if line =~ '^\s*$'
        continue
      endif

      if line =~ '^\s*\%(use\s\+\)\=v6\%(\.\d\%(\.\d\)\=\)\=;'
        set filetype=perl6 " we matched a 'use v6' declaration
      elseif line =~ '^\s*\%(\%(my\|our\)\s\+\)\=\(module\|class\|role\|enum\|grammar\)'
        set filetype=perl6 " we found a class, role, module, enum, or grammar declaration
      endif

      break " we either found what we needed, or we found a non-POD, non-comment,
            " non-Perl 6 indicating line, so bail out
    endif
  endwhile
endfunction

function! s:RetryPerl6Detection()
  call <SID>DetectPerl6()

  augroup Perl11Detection
    autocmd!
  augroup END
endfunction

augroup Perl11Detection
  autocmd!

  autocmd InsertLeave <buffer> call <SID>RetryPerl6Detection()
augroup END

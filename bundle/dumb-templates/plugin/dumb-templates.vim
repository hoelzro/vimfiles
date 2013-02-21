" Dumb Templates Plugin
" Author: Rob Hoelz <rob 'at' hoelz.ro>
" Description: A really stupid template insertion system that I wrote to
"              fulfill my limited needs.

function! s:IsFileEmpty()
  let size = getfsize(expand('%'))

  return size == 0 || size == -1
endfunction

function! s:IsDiaryFile()
  return match(expand('%:p'), 'diary') != -1
endfunction

function! s:DeterminePackageName()
  let path      = split(expand('%:p:r'), '/')
  let lib_index = -1
  let index     = 0

  for element in path
    if element ==# 'lib'
      let lib_index = index
      break
    endif

    let index = index + 1
  endfor

  if lib_index != -1
    let path = path[lib_index + 1 : ]
  endif

  return join(path, '::')
endfunction

function! s:FindCursor(lines)
  let line_no = 1

  for line in a:lines
    if line == '↑'
      let a:lines[line_no - 1] = ''
      return line_no
    endif

    let line_no = line_no + 1
  endfor

  return 0
endfunction

function! s:InsertTemplate(lines)
  let cursor_index = <SID>FindCursor(a:lines)
  normal G
  let curr_line = line('$')
  call append(curr_line, a:lines)
  if curr_line == 1
    0delete _
  endif
  normal G

  if cursor_index != 0
    call cursor(cursor_index + curr_line - 1, 1)
  else
    $normal o
  endif
endfunction

function! s:InsertPerlScriptTemplate()
  let template = [
\ '#!/usr/bin/env perl',
\ '',
\ 'use strict;',
\ 'use warnings;',
\ 'use feature qw(say);'
\ ]
  call <SID>InsertTemplate(template)
endfunction

function! s:InsertPerlModuleTemplate()
  let package_name = <SID>DeterminePackageName()

  let template = [
\ '## no critic (RequireUseStrict)',
\ 'package ' . package_name . ';',
\ '',
\ '## use critic (RequireUseStrict)',
\ 'use strict;',
\ 'use warnings;',
\ '↑',
\ '1;',
\ '',
\ '__END__',
\ '',
\ '# ABSTRACT: Description for ' . package_name,
\ '',
\ '=head1 SYNOPSIS',
\ '',
\ '=head1 DESCRIPTION',
\ '',
\ '=head1 FUNCTIONS',
\ '',
\ '=cut',
\ ]

  call <SID>InsertTemplate(template)
endfunction

function! s:InsertPerlTestTemplate()
  let template = [
\ '#!/usr/bin/env perl',
\ '',
\ 'use strict;',
\ 'use warnings;',
\ 'use Test::More tests => 1;',
\ '↑',
\ 'pass;'
\ ]

  call <SID>InsertTemplate(template)
endfunction

function! s:InsertPerlTemplate()
  " this happens when Vim checks a buffer to
  " see if it's been modified.
  if !buflisted(bufname('%'))
    return
  endif

  if ! <SID>IsFileEmpty()
    return
  endif

  let extension = expand('%:e')

  if extension == 'pl' || empty(extension)
    call <SID>InsertPerlScriptTemplate()
  elseif extension == 'pm'
    call <SID>InsertPerlModuleTemplate()
  elseif extension == 't'
    call <SID>InsertPerlTestTemplate()
  endif
endfunction

function! s:InsertRubyTemplate()
  " this happens when Vim checks a buffer to
  " see if it's been modified.
  if !buflisted(bufname('%'))
    return
  endif

  if ! <SID>IsFileEmpty()
    return
  endif

  let template = [
\ '#!/usr/bin/env ruby',
\ '↑'
\ ]

  call <SID>InsertTemplate(template)
endfunction

function! s:InsertVimWikiTemplate()
  if ! <SID>IsDiaryFile()
    return
  endif

  let template = []

  if <SID>IsFileEmpty()
    let template = [ '= ' . strftime('%A, %Y-%m-%d') . ' =' ]
  endif

  call extend(template, ['', '== ' . strftime('%H') . ':00 ==', ''])

  call <SID>InsertTemplate(template)
endfunction

augroup DumbTemplateInsertion
  autocmd!

  autocmd FileType perl    call <SID>InsertPerlTemplate()
  autocmd FileType ruby    call <SID>InsertRubyTemplate()
  autocmd FileType vimwiki call <SID>InsertVimWikiTemplate()
augroup END

" vim:sw=2 sts=2

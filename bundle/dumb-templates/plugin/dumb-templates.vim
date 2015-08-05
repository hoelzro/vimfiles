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

" XXX fix me for modules not under lib
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

function! s:InsertPSGITemplate()
  let template = [
\ '#!/usr/bin/env perl',
\ '',
\ 'use strict;',
\ 'use warnings;',
\ '',
\ 'sub {',
\ '    my ( $env ) = @_',
\ '↑',
\ '};'
\ ]

  call <SID>InsertTemplate(template)
endfunction

function! s:InsertPerlTemplate()
  " this happens when Vim checks a buffer to
  " see if it's been modified.
  if !buflisted(bufname('%'))
    return
  endif

  if !&modifiable
    return
  endif

  if &readonly
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
  elseif extension == 'psgi'
    call <SID>InsertPSGITemplate()
  endif
endfunction

function! s:InsertRubyTemplate()
  " this happens when Vim checks a buffer to
  " see if it's been modified.
  if !buflisted(bufname('%'))
    return
  endif

  if &readonly
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

  let date = strftime('%A, %Y-%m-%d')

  let template = []

  if <SID>IsFileEmpty()
    let template = [ '= ' . date . ' =' ]
  else
    let first_line = getline(1)
    if stridx(first_line, date) == -1
      return
    endif
  endif

  call extend(template, ['', '== ' . strftime('%H') . ':00 ==', ''])

  call <SID>InsertTemplate(template)
endfunction

function! s:DetermineJavaPackageName()
  let path = split(expand('%:p:h'), '/')
  return ''
endfunction

function! s:InsertJavaTemplate()
  " this happens when Vim checks a buffer to
  " see if it's been modified.
  if !buflisted(bufname('%'))
    return
  endif

  if &readonly
    return
  endif

  if ! <SID>IsFileEmpty()
    return
  endif

  let package_name = <SID>DetermineJavaPackageName()
  let class_name = substitute(expand('%:t'), '\.java$', '', '')

  let template = [
\ 'public class ' . class_name . ' {',
\ '    public static void main(String[] args) {',
\ '↑',
\ '    }',
\ '}',
\ ]

  if !empty(package_name)
    let template = extend(template, ['package ' . package_name . ';', ''], 0)
  endif

  call <SID>InsertTemplate(template)
endfunction

function! s:InsertDevJournalTemplate()
  let months   = split('Nothing January February March April May June July August September October November December', '\s\+')
  let suffixes = { 1: 'st', 21: 'st', 31: 'st', 2: 'nd', 22: 'nd', 3: 'rd', 23: 'rd' }

  let path = expand('%:p')

  if path !~ 'dev-journal'
    return
  endif

  let filename             = expand('%:t')
  let date_match           = matchlist(filename, '^\(\d\+\)-\(\d\+\)-\(\d\+\)')
  let [ year, month, day ] = map(date_match[1:3], 'str2nr(substitute(v:val, "^0\\+", "", "g"))')

  let template = [
\   printf('# dev journal for %s %d%s, %d', months[month], day, get(suffixes, day, 'th'), year),
\   ''
\ ]
  call <SID>InsertTemplate(template)
endfunction

augroup DumbTemplateInsertion
  autocmd!

  autocmd FileType perl    call <SID>InsertPerlTemplate()
  autocmd FileType ruby    call <SID>InsertRubyTemplate()
  autocmd FileType vimwiki call <SID>InsertVimWikiTemplate()
  autocmd FileType java    call <SID>InsertJavaTemplate()

  autocmd FileType markdown call <SID>InsertDevJournalTemplate()
augroup END

" vim:sw=2 sts=2

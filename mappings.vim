mapclear!
abclear

noremap <C-p> :tabprev<CR>
noremap <C-n> :tabnext<CR>
noremap gf <C-w>gf

if exists(':TlistToggle')
  noremap <F2> :TlistToggle<CR>
endif
noremap <Leader>f $zf%

noremap <Leader>i :call InsertHeader()<CR>
noremap <Leader>tt :call RotateKeywords()<CR>
noremap <Leader>ss :call ToggleSQLMode()<CR>

" custom abbrevations for Perl modules I use a lot
function! LeaderAbbreviate(lhs, rhs)
  let code = "inoremap <Leader>" . a:lhs . " " . a:rhs
  execute l:code
endfunction

let ddc_installed = system("perl -e '$ok = eval { require Data::Dumper::Concise }; print($ok ? 1 : 0);'")

if ddc_installed
  call LeaderAbbreviate('uddc', 'use Data::Dumper::Concise;')
else
  call LeaderAbbreviate('uddc', 'use Data::Dumper;')
endif

call LeaderAbbreviate('uddp', 'use Data::Printer;')
call LeaderAbbreviate('utm',  'use Test::More;')

let perl_version       = system("perl -e 'print $]'")
let perl_version       = substitute(perl_version, '^5[.]', '', '')
let perl_major_version = substitute(matchstr(perl_version, '...'), '^0*', '', '')

if perl_major_version >= 10
  call LeaderAbbreviate('ufs',  'use feature qw(say);')
else
  call LeaderAbbreviate('ufs',  'use Perl6::Say;')
end

inoremap <C-A> <nop>
inoremap <C-@> <nop>
inoremap <C-c> <nop>
nnoremap zo zO
inoreabbrev deafult default
inoreabbrev langauge language

" Make Y behave like other capitals
noremap Y y$

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cabbrev q1 q!
cabbrev ssu sus
cabbrev us sus
cabbrev Sus sus
cnoreabbrev su sus
cnoreabbrev Help help
cnoreabbrev tanbew tabnew

vnoremap <Leader>= :Tabularize assignment<CR>

nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>sv :source $MYVIMRC<CR>

let s:handy_mappings = []

function! s:DefineHandyMapping(char, command)
  call add(s:handy_mappings, [ a:char, a:command ])
  execute 'nnoremap <C-x>' . a:char . ' ' . a:command . '<CR>'
endfunction

function! s:DisplayHandyMappings()
  for pair in s:handy_mappings
    echo pair[0] . '	' . pair[1]
  endfor
endfunction

call <SID>DefineHandyMapping('n', ':set number!')
call <SID>DefineHandyMapping('l', ':set list!')
call <SID>DefineHandyMapping('s', ':set spell!')
call <SID>DefineHandyMapping('i', ':set ignorecase!')
call <SID>DefineHandyMapping('p', ':set paste!')

nnoremap <C-x>? :call <SID>DisplayHandyMappings()<CR>
nnoremap <C-x><C-x> <C-x>

vnoremap . :normal .<CR>
vnoremap , :normal A,<CR>

nnoremap <Left> :previous<CR>
nnoremap <Right> :next<CR>

" tmux-friendly window mappings

function! FigureOutWindows(vim_direction, tmux_direction)
  let current_tab = tabpagenr()
  let num_windows = tabpagewinnr(current_tab, '$')

  " it would be nice if this determined if a window existed
  " in the direction we're going rather than just counting
  if !empty($TMUX) && num_windows == 1
    call system('tmux select-pane -' . a:tmux_direction)
  else
    execute 'wincmd ' . a:vim_direction
  endif
endfunction

nnoremap <silent> <C-w>h :call FigureOutWindows('h', 'L')<CR>
nnoremap <silent> <C-w>j :call FigureOutWindows('j', 'D')<CR>
nnoremap <silent> <C-w>k :call FigureOutWindows('k', 'U')<CR>
nnoremap <silent> <C-w>l :call FigureOutWindows('l', 'R')<CR>

function! SwapLastTwoChars()
  let cmdline = getcmdline()
  let cursor  = getcmdpos()

  if cursor > len(cmdline)
    let cursor = len(cmdline)
  endif

  let cursor = cursor - 1 " 0-index it

  return cmdline[:cursor - 2] . cmdline[cursor] . cmdline[cursor - 1] .  cmdline[cursor + 1:]
endfunction

cnoremap <silent> <C-t> <C-\>eSwapLastTwoChars()<CR>

" work in concert with a CompleteDone mapping autocommands.vim
function! ForceCaseSensitiveCompletion()
  let b:oldignorecase=&l:ignorecase
  setlocal noignorecase

  iunmap <C-p>
  iunmap <C-n>
  iunmap <C-x>
  return ''
endfunction

function! RestoreOldCaseSensitivity()
  if !has_key(b:, 'oldignorecase')
    return
  endif

  let &l:ignorecase=b:oldignorecase
  unlet b:oldignorecase

  inoremap <C-p> <C-r>=ForceCaseSensitiveCompletion()<CR><C-p>
  inoremap <C-n> <C-r>=ForceCaseSensitiveCompletion()<CR><C-n>
  inoremap <C-x> <C-r>=ForceCaseSensitiveCompletion()<CR><C-x>
endfunction

inoremap <C-p> <C-r>=ForceCaseSensitiveCompletion()<CR><C-p>
inoremap <C-n> <C-r>=ForceCaseSensitiveCompletion()<CR><C-n>
inoremap <C-x> <C-r>=ForceCaseSensitiveCompletion()<CR><C-x>

nnoremap ga :UnicodeName<CR>

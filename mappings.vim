mapclear
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
inoremap <Esc> <nop>
inoremap <C-c> <Esc>
nnoremap zo zO
inoreabbrev deafult default

" Make Y behave like other capitals
noremap Y y$

cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cabbrev q1 q!
cabbrev ssu sus
cabbrev us sus
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

function! LogLastBadWord(consider_previous)
  if a:consider_previous
    let previous_position             = get(b:, 'last_word_previous_position', [])
    let current_position              = getpos('.')
    let b:last_word_previous_position = [ current_position[1], current_position[2] ]

    if !empty(previous_position)
      if previous_position[0] == current_position[1] && (previous_position[1] - 1) == current_position[2]
        return
      endif
    endif
  endif

  if !has_key(b:, 'last_word_bad_words')
    let b:last_word_bad_words = []
  endif

  call add(b:last_word_bad_words, expand('<cword>'))
endfunction

function! FlushBadWords()
  let bad_words = get(b:, 'last_word_bad_words', [])

  if empty(bad_words)
    return
  endif

  let old_bad_words = []

  let filename = expand('~/.vim/bad-words')

  if filereadable(filename)
    let old_bad_words = readfile(filename)
  endif

  call extend(old_bad_words, bad_words)
  call writefile(old_bad_words, filename)
endfunction

function! SwapLastTwoChars()
  let cmdline = getcmdline()
  let cursor  = getcmdpos()

  if cursor > len(cmdline)
    let cursor = len(cmdline)
  endif

  let cursor = cursor - 1 " 0-index it

  return cmdline[:cursor - 2] . cmdline[cursor] . cmdline[cursor - 1] .  cmdline[cursor + 1:]
endfunction

" XXX consider this for command mode too
inoremap <silent> <Backspace> <C-o>:call LogLastBadWord(1)<CR><Backspace>
inoremap <silent> <C-w>       <C-o>:call LogLastBadWord(0)<CR><C-w>

cnoremap <silent> <C-t> <C-\>eSwapLastTwoChars()<CR>

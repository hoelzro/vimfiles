" luarefvim plugin
" This is somewhat based on CRefVim
" Maintainer: Luis Carvalho <lexcarvalho@gmail.com>
" Last Change: Jun, 3, 2005
" Version: 0.2

" initial setup: avoid loading more than once
if exists("loaded_luarefvim")
	finish
endif
let loaded_luarefvim = 1

function s:SID()
    return '<SNR>' . matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$') . '_'
endfunction

" mappings:
vmap <silent> <unique> <Leader>lr y:call <SID>LookUp('<c-r>"')<CR>
nmap <silent> <unique> <Leader>lr  :call <SID>LookUp(expand("<cword>"))<CR>
nmap <silent> <unique> <Leader>LR  :call <SID>LookUp(input("Enter the topic to lookup: ", "", "customlist," . <SID>SID() . "CompleteLuaTags"))<CR>

let s:tags_path = expand("<sfile>:p:h:h") . '/doc/tags'

function s:CompleteLuaTags(ArgLead, CmdLine, CursorPos)
    let l:oldtags = &tags
    let &tags     = s:tags_path
    let l:matches = taglist("^lrv-" . a:ArgLead . ".*")
    let &tags     = l:oldtags
    let l:results = []
    for m in l:matches
        call add(l:results, substitute(m['name'], '^lrv-', '', ''))
    endfor
    return l:results
endfunction

function <SID>LookUp(str)
        if a:str == ""
                return
	elseif a:str == "--" "comment?
		silent! execute ":help lrv-comment"
	elseif a:str == ""
		silent! execute ":help luaref"
	else
		silent! execute ":help lrv-" . a:str
		if v:errmsg != ""
			echo "luarefvim: \`" . a:str . "\' not found"
		endif
	endif
endfunction


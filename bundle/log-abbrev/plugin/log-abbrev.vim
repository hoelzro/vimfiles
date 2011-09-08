if exists('g:loaded_log_abbrev')
    finish
endif

let g:loaded_log_abbrev = 1

function s:InsertPrintLog()
    normal! aprint STDERR "\n";
    normal! hhh
    startinsert
endfunction

function s:InsertSayLog()
    normal! asay STDERR "";
    normal h
    startinsert
endfunction

function s:InsertCatalystLog()
    normal! a$c->log->info("");
    normal! hh
    startinsert
endfunction

function s:InsertJSLog()
    normal! aconsole.log("");
    normal! hh
    startinsert
endfunction

function s:InsertNone()
    normal! alog("");
    normal! hh
    startinsert
endfunction

function s:DetermineLogType()
    if     &filetype == 'perl'
        let b:insert_log_type = 'print'
        let l:path      = expand('%:p')
        let l:match_idx = match(l:path, 'lib/\w\+/Controller/')

        if l:match_idx == -1
            let l:lineno = 1
            while l:lineno < 100
                let l:line = getline(l:lineno)
                if match(l:line, '^use') != -1
                    if match(l:line, '^use\s\+feature') != -1 && match(l:line, 'say') != -1
                        let b:insert_log_type = 'say'
                        break
                    else
                        let l:matches = matchlist(l:line, '\M^use\s\+5.0\*\(\d\+\)')
                        if ! empty(l:matches)
                            let l:subversion = l:matches[1]
                            if l:subversion >= 10
                                let b:insert_log_type = 'say'
                                break
                            endif
                        endif
                    endif
                endif
                let l:lineno = l:lineno + 1
            endwhile
        else
            let b:insert_log_type = 'catalyst'
        end
    elseif &filetype == 'javascript'
        let b:insert_log_type = 'js'
    else
        let b:insert_log_type = 'none'
    endif
endfunction

function s:InsertLog()
    if ! exists('b:insert_log_type')
        call s:DetermineLogType()
    endif

    if     b:insert_log_type == 'print'
        call s:InsertPrintLog()
    elseif b:insert_log_type == 'say'
        call s:InsertSayLog()
    elseif b:insert_log_type == 'catalyst'
        call s:InsertCatalystLog()
    elseif b:insert_log_type == 'js'
        call s:InsertJSLog()
    elseif b:insert_log_type == 'none'
        call s:InsertNone()
    else
        throw "Invalid log type '" . b:insert_log_type . "'"
    endif
endfunction

inoremap <Leader>ll <ESC>:call <SID>InsertLog()<CR>

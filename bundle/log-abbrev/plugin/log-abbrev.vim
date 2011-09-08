if exists('g:loaded_log_abbrev')
    finish
endif

let g:loaded_log_abbrev = 1

let g:log_expressions = {}
let g:log_expressions['print']    = 'print STDERR "^\n";'
let g:log_expressions['say']      = 'say STDERR "^";'
let g:log_expressions['catalyst'] = '$c->log->info("^");'
let g:log_expressions['js']       = 'console.log("^");'
let g:log_expressions['none']     = 'log("^");'

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

function s:ExpandLogExpression(expr)
    let l:expr_wo_marker = substitute(a:expr, '\^', '', '')
    let l:marker_index   = match(a:expr, '\^')
    let l:left_count     = strlen(a:expr) - l:marker_index - 2

    execute 'normal! a' . l:expr_wo_marker
    execute 'normal! ' . repeat('h', l:left_count)
    startinsert
endfunction

function s:InsertLog()
    if ! exists('b:insert_log_type')
        call s:DetermineLogType()
    endif

    call s:ExpandLogExpression(g:log_expressions[b:insert_log_type])
endfunction

inoremap <Leader>ll <ESC>:call <SID>InsertLog()<CR>

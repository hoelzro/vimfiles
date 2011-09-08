if exists('g:loaded_log_abbrev')
    finish
endif

let g:loaded_log_abbrev = 1

let s:log_predicates  = []
let s:log_expressions = {}

" Internal functions
function s:DetermineLogType()
    for pair in s:log_predicates
        let l:name      = pair[0]
        let l:Predicate = pair[1]

        let found = call(l:Predicate, [])
        if found
            let b:insert_log_type = l:name
            break
        endif
    endfor
endfunction

function s:ExpandLogExpression(expr)
    let l:expr_wo_marker = substitute(a:expr, '\^', '', '')
    let l:marker_index   = match(a:expr, '\^')
    let l:left_count     = strlen(a:expr) - l:marker_index - 2

    execute 'normal! a' . l:expr_wo_marker
    execute 'normal! ' . repeat('h', l:left_count)
    startinsert
endfunction

function s:SID()
    return '<SNR>' . matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$') . '_'
endfunction

" Public interface (functions)
function AddLogType(name, expr, Predicate)
    if has_key(s:log_expressions, a:name)
        throw 'A log abbreviation already exists for ''' . a:name . ''''
    endif

    call insert(s:log_predicates, [ a:name, a:Predicate ])
    let s:log_expressions[a:name] = a:expr
endfunction

function RemoveLogType(name)
    if ! has_key(s:log_expressions, a:name)
        throw 'No log abbreviation exists for ''' . a:name . ''''
    endif
    call remove(s:log_expressions, a:name)
    let l:index = 0
    for pair in s:log_predicates
        if pair[0] == a:name
            break
        endif
        let l:index = l:index + 1
    endfor
    call remove(s:log_predicates, l:index)
endfunction

function LogTypes()
    let l:retlist = []
    for pair in s:log_predicates
        call add(l:retlist, pair[0])
    endfor

    return l:retlist
endfunction

function InsertLog()
    if ! exists('b:insert_log_type')
        call s:DetermineLogType()
    endif

    call s:ExpandLogExpression(s:log_expressions[b:insert_log_type])
endfunction

" Log type predicates
function s:IsLogTypePrint()
    return &filetype == 'perl'
endfunction

function s:IsLogTypeSay()
    if &filetype != 'perl'
        return 0
    endif

    let l:lineno = 1
    while l:lineno < 100
        let l:line = getline(l:lineno)
        if match(l:line, '^use') != -1
            if match(l:line, '^use\s\+feature') != -1 && match(l:line, 'say') != -1
                return 1
                break
            else
                let l:matches = matchlist(l:line, '\M^use\s\+5.0\*\(\d\+\)')
                if ! empty(l:matches)
                    let l:subversion = l:matches[1]
                    if l:subversion >= 10
                        return 1
                        break
                    endif
                endif
            endif
        endif
        let l:lineno = l:lineno + 1
    endwhile

    return 0
endfunction

function s:IsLogTypeCatalyst()
    if &filetype != 'perl'
        return 0
    endif
    let l:path      = expand('%:p')
    let l:match_idx = match(l:path, 'lib/\w\+/Controller/')
    return l:match_idx != -1
endfunction

function s:IsLogTypeJs()
    return &filetype == 'javascript'
endfunction

function s:IsLogTypeNone()
    return 1
endfunction

" log predicates are call in the reverse order of their addition
call AddLogType('none',     'log("^");',           function(s:SID() . 'IsLogTypeNone'))
call AddLogType('js',       'console.log("^");',   function(s:SID() . 'IsLogTypeJs'))
call AddLogType('print',    'print STDERR "^\n";', function(s:SID() . 'IsLogTypePrint'))
call AddLogType('say',      'say STDERR "^";',     function(s:SID() . 'IsLogTypeSay'))
call AddLogType('catalyst', '$c->log->info("^");', function(s:SID() . 'IsLogTypeCatalyst'))

" Function-command bridge functions
function s:AddLogTypeHelper(name, expr, predicate_name)
    let l:Predicate = function(a:predicate_name)

    call AddLogTypeHelper(a:name, a:name, l:Predicate)
endfunction

function s:RemoveLogTypeHelper(name)
    call RemoveLogType(a:name)
endfunction

function s:PrintLogTypes()
    let l:types = LogTypes()
    for type in l:types
        echomsg type
    endfor
endfunction

" Public interface (commands)
command -nargs=* AddLogType call <SID>AddLogTypeHelper(<f-args>)
command -nargs=* RemoveLogType call <SID>RemoveLogTypeHelper(<f-args>)
command LogTypes call <SID>PrintLogTypes()

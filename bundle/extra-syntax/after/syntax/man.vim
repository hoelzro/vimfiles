function s:FindSections()
    let sections  = []
    let locations = {}
    let nlines    = line('$')
    let lineno    = 1

    while lineno <= nlines
        let line    = getline(lineno)
        let matches = matchstr(line, "\\C^[A-Z][-A-Z0-9 ]\\+$")

        if !empty(matches)
            call add(sections, line)
            let locations[line] = lineno
        endif
        let lineno  = lineno + 1
    endwhile

    return [ sections, locations ]
endfunction

" hey!
function GotoSection()
    let locations = b:locations
    let curline   = getline('.')
    :quit!
    call cursor(locations[curline], 1)
endfunction

" popup menus in Vim?
" preview menus in Vim?
" better way to open 'preview' window
function s:ViewManSections()
    let [ sections, locations ] = s:FindSections()
    below 10new
    setlocal modifiable
    call append('.', sections)
    normal ggdd
    setlocal nomodifiable
    let b:locations = locations
    " oy
    map <buffer> <silent> <Return> :call GotoSection()<CR>
endfunction

" hit enter on section names?
map <buffer> <silent> <F2> :call <SID>ViewManSections()<CR>

" Vim plugin for adding temporal marks to your undo tree
" Last Change: July 26, 2011
" Maintainer: Rob Hoelz <rob@hoelz.ro>
" License: " Copyright (c) 2011 Rob Hoelz <rob@hoelz.ro>
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal in the Software without restriction, including without limitation the
" rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
" sell copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
" IN THE SOFTWARE.

if exists("g:loaded_temporal_marks")
    finish
endif

if v:version < 700
    echomsg "The temporal marks plugin requires Vim 7 or higher"
    finish
endif
let g:loaded_temporal_marks = 1

function s:GetTemporalMarks()
    if ! exists('b:temporal_marks')
        let b:temporal_marks = {}
    endif

    return b:temporal_marks
endfunction

function s:ListTemporalMarks()
    let marks  = s:GetTemporalMarks()
    let names  = keys(marks)
    let maxlen = 0

    for k in names
        if strlen(k) > maxlen
            let maxlen = strlen(k)
        endif
    endfor

    let format = "%" . maxlen . "s %s"

    for m in sort(keys(marks))
        echo printf(format, m, marks[m])
    endfor
endfunction

function s:AddTemporalMark(m)
    let marks = s:GetTemporalMarks()
    let marks[a:m] = changenr()
endfunction

function s:JumpToTemporalMark(m)
    let marks = s:GetTemporalMarks()
    if has_key(marks, a:m)
        execute "undo " . marks[a:m]
    else
        echomsg "No such mark '" . a:m . "'"
    endif
endfunction

command -nargs=0 ListTemporalMarks  call s:ListTemporalMarks()
command -nargs=1 AddTemporalMark    call s:AddTemporalMark(<q-args>)
command -nargs=1 JumpToTemporalMark call s:JumpToTemporalMark(<q-args>)

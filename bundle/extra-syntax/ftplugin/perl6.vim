call AddKeywordType('Perl identifier', 'a-z,A-Z,48-57,_,:')
call AddKeywordType('Perl 6 identifier', 'a-z,A-Z,48-57,_,:,-')

let &iskeyword = 'a-z,A-Z,48-57,_,:,-'

nnoremap <silent> gd :let @/ = '\(token\\|rule\\|regex\\|sub\\|method\\|submethod\\|class\\|role\\|grammar\)\s\+\<' . expand('<cword>') . '\>' <Bar> normal n <CR>

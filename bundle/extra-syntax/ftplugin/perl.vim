call AddKeywordType('Perl identifier', 'a-z,A-Z,48-57,_,:')

let &iskeyword = 'a-z,A-Z,48-57,_,:'

inoremap (<<' (<<'END_SQL');<CR><C-o>0END_SQL<C-o>O
inoremap (<<" (<<"END_SQL");<CR><C-o>0END_SQL<C-o>O

let b:manpageview_sections = [2, 3, 4, 5, 7, 1, 8, 9, 6, 'n']

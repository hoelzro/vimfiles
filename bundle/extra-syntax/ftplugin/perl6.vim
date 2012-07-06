call AddKeywordType('Perl identifier', 'a-z,A-Z,48-57,_,:')
call AddKeywordType('Perl 6 identifier', 'a-z,A-Z,48-57,_,:,-')

let &iskeyword = 'a-z,A-Z,48-57,_,:,-'

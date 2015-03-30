setlocal omnifunc=pythoncomplete#Complete
setlocal foldmethod=expr
setlocal foldexpr=python_fold#GetPythonFold(v:lnum)
setlocal foldtext=python_fold#PythonFoldText()

set nocindent
set smartindent
set cinwords=if,elif,else,for,while,try,except,finally,def,class
filetype plugin indent on

inoremap <Leader>upp from pprint import pprint as pp

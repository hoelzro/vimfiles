setlocal omnifunc=pythoncomplete#Complete
setlocal foldmethod=expr
setlocal foldexpr=python_fold#GetPythonFold(v:lnum)
setlocal foldtext=python_fold#PythonFoldText()

set cinwords=if,elif,else,for,while,try,except,finally,def,class

inoremap <Leader>upp from pprint import pprint as pp
inoremap <Leader>udb import pdb; pdb.set_trace()

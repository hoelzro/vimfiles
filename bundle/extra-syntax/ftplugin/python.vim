setlocal omnifunc=pythoncomplete#Complete
setlocal foldmethod=expr
setlocal foldexpr=python_fold#GetPythonFold(v:lnum)
setlocal foldtext=python_fold#PythonFoldText()

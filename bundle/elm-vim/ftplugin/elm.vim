" plugin for Elm (http://elm-lang.org/)

if exists('b:did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

" Settings
if !exists("g:elm_jump_to_error")
	let g:elm_jump_to_error = 1
endif

if !exists("g:elm_make_output_file")
	let g:elm_make_output_file = "elm.js"
endif

if !exists("g:elm_make_show_warnings")
	let g:elm_make_show_warnings = 0
endif

setlocal omnifunc=elm#Complete

" Commands
command -buffer -nargs=? -complete=file ElmMake call elm#Make(<f-args>)
command -buffer ElmMakeMain call elm#Make("Main.elm")
command -buffer -nargs=? -complete=file ElmTest call elm#Test(<f-args>)
command -buffer ElmRepl call elm#Repl()
command -buffer ElmErrorDetail call elm#ErrorDetail()
command -buffer ElmShowDocs call elm#ShowDocs()
command -buffer ElmBrowseDocs call elm#BrowseDocs()

" Mappings
nnoremap <silent> <Plug>(elm-make) :<C-u>call elm#Make()<CR>
nnoremap <silent> <Plug>(elm-make-main) :<C-u>call elm#Make("Main.elm")<CR>
nnoremap <silent> <Plug>(elm-test) :<C-u>call elm#Test()<CR>
nnoremap <silent> <Plug>(elm-repl) :<C-u>call elm#Repl()<CR>
nnoremap <silent> <Plug>(elm-error-detail) :<C-u>call elm#ErrorDetail()<CR>
nnoremap <silent> <Plug>(elm-show-docs) :<C-u>call elm#ShowDocs()<CR>
nnoremap <silent> <Plug>(elm-browse-docs) :<C-u>call elm#BrowseDocs()<CR>

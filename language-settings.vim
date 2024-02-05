" Settings for language syntax files

" Assembly
let asmsyntax='nasm'

" C
let c_gnu=1
let c_space_errors=1
let c_curly_error=1
let c_syntax_for_h=1
let c_fold_blocks=1

" Doxygen
let load_doxygen_syntax=1
let doxygen_enhanced_color=1

" Go
let g:go_auto_type_info = 1
let g:go_doc_popup_window = 1
let g:go_template_autocreate = 0
let g:go_alternate_mode = 'botright vnew'
let g:go_fmt_command = 'gopls'
"let g:go_highlight_string_spellcheck = 0
"let g:go_diagnostics_enabled = 0

" Haskell
let hs_highlight_types = 1
let hs_highlight_more_types = 1

" Java
let java_highlight_all=1
let java_highlight_functions=1

" JavaScript
let javaScript_fold=1

" Lisp
let lisp_rainbow=1

" Lua
let lua_version=5
let lua_subversion=3

" Perl
let perl_include_pod=1
let perl_want_scope_in_variables=1
let perl_extended_vars=1
let perl_fold=1
let perl_nofold_packages=1
let perl_fold_anonymous_subs=1
let perl_no_subprototype_error=1
let perl_sub_signatures=1
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linters['perl'] = ['perl']


" Python
let python_highlight_space_errors=1
let python_highlight_all=1
let pyindent_continue='&shiftwidth'
let pyindent_open_paren='&shiftwidth'
let pyindent_nested_paren='&shiftwidth'
let g:SimpylFold_fold_import = 0

" Ruby
let ruby_space_errors=1
let ruby_fold=1

" Rust
let no_rust_conceal=1

" Shell
let is_bash=1

" SQL
let sql_type_default='sqlite'
let g:omni_sql_no_default_maps=1

" Terraform
let g:terraform_align=1
let g:terraform_fold_sections=1

" TeX
let tex_fold_enabled=1

if exists(':ALEEnable')
  augroup ALEOptIn
    autocmd!

    autocmd FileType c :ALEEnable
    autocmd FileType elm :ALEEnable
    autocmd FileType lua :ALEEnable
    autocmd FileType perl :ALEEnable
    autocmd FileType typescript :ALEEnable
  augroup END
endif

" Vim
let g:vimsyn_folding = 'f' " fold functions
let g:vimsyn_embed   = 'l' " highlight Lua heredocs

function! GetLSPRoot(server_info)
  let cargo_location = lsp#utils#find_nearest_parent_file(expand('%:p'), 'Cargo.toml')
  if cargo_location != ''
    let cargo_location = substitute(cargo_location, 'Cargo\.toml$', '', '')
    return lsp#utils#path_to_uri(cargo_location)
  endif

  let git_location = lsp#utils#find_nearest_parent_directory(expand('%:p'), '.git')
  if git_location != ''
    let git_location = substitute(git_location, '\.git/$', '', '')
    return lsp#utils#path_to_uri(git_location)
  else
    return lsp#utils#get_default_root_uri()
  endif
endfunction

if executable('gopls')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['env', 'TMPDIR=/tmp/gotmp', 'gopls']},
    \ 'allowlist': ['go'],
    \ 'root_uri': function('GetLSPRoot'),
    \ 'initialization_options': {'gofumpt': v:true},
    \ })

  autocmd BufWritePre *.go :LspCodeActionSync source.organizeImports
endif

if executable('elm-language-server')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'elm-language-server',
    \ 'cmd': {server_info->['elm-language-server']},
    \ 'allowlist': ['elm'],
    \ 'root_uri': function('GetLSPRoot'),
    \ 'initialization_options': {'elmPath': 'elm', 'runtime': 'node', 'elmFormatPath': 'elm-format', 'elmTestPath': 'elm-test', 'onlyUpdateDiagnosticsOnSave': 1, 'disableElmLSDiagnostics': 1},
    \ })
endif

if executable('clangd')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'clangd',
    \ 'cmd': {server_info->['clangd']},
    \ 'allowlist': ['c', 'cpp'],
    \ 'root_uri': function('GetLSPRoot'),
    \ })
endif

if executable('yaml-language-server')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'yaml-language-server',
    \ 'cmd': ['yaml-language-server', '--stdio'],
    \ 'allowlist': ['yaml'],
    \ 'root_uri': {_->'/home/rob'},
    \ 'workspace_config': {'yaml':{'schemas':{
    \   'kubernetes':'*.yaml',
    \   'https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json': 'docker-compose.yaml',
    \   'https://json.schemastore.org/github-workflow.json': '.github/workflows/*.yaml',
    \   'https://json.schemastore.org/github-action.json': '.github/actions/*/action.yaml',
    \ }}},
    \ })
endif

if executable('terraform-ls')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'terraform-ls',
    \ 'cmd': ['terraform-ls', 'serve', '-log-file=/tmp/tf-lsp.log'],
    \ 'allowlist': ['terraform'],
    \ 'root_uri': function('GetLSPRoot'),
    \ })
endif

if executable('rust-analyzer')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'rust-analyzer',
    \ 'cmd': ['rust-analyzer'],
    \ 'allowlist': ['rust'],
    \ 'root_uri': function('GetLSPRoot'),
    \ })
endif

if executable('pylsp')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'pylsp',
    \ 'cmd': ['pylsp'],
    \ 'allowlist': ['python'],
    \ 'root_uri': function('GetLSPRoot'),
    \ 'workspace_config': {'pylsp':{
    \   'plugins': {
    \     'flake8': {
    \       'enabled': v:false,
    \     },
    \     'pyflakes': {
    \       'enabled': v:false,
    \     },
    \     'pycodestyle': {
    \       'enabled': v:false,
    \     },
    \   },
    \ }},
    \ })
endif

" XXX look for package.json for root_uri?
if executable('typescript-language-server')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'tsserver',
    \ 'cmd': ['typescript-language-server', '--stdio'],
    \ 'allowlist': ['javascript', 'typescript'],
    \ 'root_uri': function('GetLSPRoot'),
    \ 'initialization_options': {'disableAutomaticTypingAcquisition': v:true, 'preferences': {'quotePreference': 'single'}},
    \ 'workspace_config': {'javascript':{
    \   'format': {
    \     'indentSize': 2,
    \     'insertSpaceAfterKeywordsInControlFlowStatements': v:false,
    \  },
    \ }},
    \ })
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.go call execute('LspDocumentFormatSync') | call execute('LspCodeActionSync source.organizeImports')
endfunction

augroup lsp_install
  autocmd!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_echo_cursor          = 0
let g:lsp_diagnostics_highlights_enabled   = 0
let g:lsp_diagnostics_float_cursor         = 1
let g:lsp_diagnostics_signs_enabled        = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_use_native_client = 1
let g:lsp_document_code_action_signs_enabled = 0

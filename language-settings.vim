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
let lua_subversion=1

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

lua <<END_LUA
local has_lsp, lsp = pcall(require, 'nvim_lsp')

if not has_lsp then
  return
end

local common_callbacks = {
  -- XXX load up the quickfix list, and maybe only right after a save or something
  -- XXX that or show a sign and have hovering over the line do things
  -- XXX also, just do compiler errors (reasonable ones - I often know about missing imports, and some lint rules would be good too)
  ['textDocument/publishDiagnostics'] = function() end,
}

local function set_up_lsp_environment()
  vim.api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {
    silent = true,
  })

  vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {
    silent = true,
  })

  vim.api.nvim_buf_set_keymap(0, 'n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', {
    silent = true,
  })

  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', {
    silent = true,
  })

  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)'
end

lsp.elmls.setup{
  on_attach = set_up_lsp_environment,
  callbacks = common_callbacks,
}

lsp.gopls.setup{
  on_attach = set_up_lsp_environment,
  callbacks = common_callbacks,
}
END_LUA

if executable('gopls')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls']},
    \ 'allowlist': ['go'],
    \ })
endif

if executable('elm-language-server')
  " XXX wrap me in an augroup
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'elm-language-server',
    \ 'cmd': {server_info->['elm-language-server']},
    \ 'allowlist': ['elm'],
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
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  autocmd!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_diagnostics_enabled = 0

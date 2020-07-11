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

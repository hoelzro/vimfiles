hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = expand("<sfile>:t:r")

hi Normal	ctermfg=252	ctermbg=234	cterm=NONE
hi Search	ctermfg=NONE	ctermbg=63	cterm=NONE
hi Ignore	ctermfg=16	ctermbg=NONE
hi Todo		ctermfg=88	ctermbg=186	cterm=NONE
hi Comment	ctermfg=244	ctermbg=NONE	cterm=NONE

hi! link	Statement	Normal
hi! link	Constant	Normal
hi! link	Identifier	Normal
hi! link	PreProc		Normal
hi! link	Type		Normal
hi! link	Special		Normal
hi! link	Underlined	Normal
hi! link	Error		Normal
hi! link	LineNr		Normal
hi! link	Title		Normal

if v:version >= 700 && has('spell')
  hi SpellBad	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
  hi SpellCap	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
  hi SpellRare	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
  hi SpellLocal	cterm=undercurl	ctermbg=NONE	ctermfg=NONE
endif

hi MatchParen	ctermfg=NONE	ctermbg=90
hi TabLine	cterm=underline
hi TabLineFill	cterm=underline
hi Underlined	cterm=underline
hi CursorLine	cterm=underline

" XXX are these redundant?
hi link		String		Constant
hi link		Character	Number
hi link		SpecialChar	LineNr
hi link		Tag		Identifier
hi link		cCppOut		LineNr
hi link		Warning		MoreMsg
hi link		Notice		Constant

" Language: NQP
" Maintainer: vim-perl <vim-perl@googlegroups.com>
" Author: Rob Hoelz <rob AT hoelz.ro>
" Homepage:      http://github.com/vim-perl/vim-perl
" Bugs/requests: http://github.com/vim-perl/vim-perl/issues
" Last Change:   {{LAST_CHANGE}}

if exists('b:current_syntax')
  finish
endif

runtime! syntax/perl6.vim

syntax match nqpAssignmentBad display '\(:\)\@<!=' containedin=ALLBUT,p6String,p6Comment contained
" XXX nqp::*

if version >= 508 || !exists("did_perl6_syntax_inits")
  if version < 508
      let did_perl6_syntax_inits = 1
      command -nargs=+ HiLink hi link <args>
  else
      command -nargs=+ HiLink hi def link <args>
  endif

  HiLink nqpAssignmentBad p6Error

  delcommand HiLink
endif

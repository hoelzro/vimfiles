" Vim syntax file loader
" Language:    SQLite (based off of Paul Moore's sqloracle.vim)
" Maintainer:  Rob Hoelz <rob@hoelz.ro>
" Last Change: Sat Jun 11 5:30 PM
" Version:     1.0

" Description: Checks for a:
"                  buffer local variable,
"                  global variable,
"              If the above exist, it will source the type specified.
"              If none exist, it will source the default sql.vim file.
"
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

" The SQL reserved words, defined as keywords.

syn keyword sqlSpecial  false null true

syn keyword sqlKeyword abort action add after all
syn keyword sqlKeyword as asc attach autoincrement before begin
syn keyword sqlKeyword by cascade case cast check collate column
syn keyword sqlKeyword conflict constraint cross current_date
syn keyword sqlKeyword current_time current_timestamp database default
syn keyword sqlKeyword deferrable deferred desc detach
syn keyword sqlKeyword each else end except exclusive
syn keyword sqlKeyword fail for foreign from full glob group having if ignore
syn keyword sqlKeyword immediate index indexed initially inner
syn keyword sqlKeyword instead into is isnull join key left
syn keyword sqlKeyword limit match natural no notnull null of offset on
syn keyword sqlKeyword order outer plan pragma primary query raise references
syn keyword sqlKeyword regexp reindex release replace restrict right
syn keyword sqlKeyword row table temp temporary
syn keyword sqlKeyword then to transaction trigger unique using
syn keyword sqlKeyword vacuum values view virtual when where

syn keyword sqlOperator	not and or
syn keyword sqlOperator	in all between exists
syn keyword sqlOperator	like escape
syn keyword sqlOperator union intersect
syn keyword sqlOperator distinct

syn keyword sqlStatement alter analyze commit create
syn keyword sqlStatement delete drop explain insert
syn keyword sqlStatement rename rollback savepoint select set
syn keyword sqlStatement update

syn keyword sqlType	blob char clob double float int integer long none null number numeric real text varchar

" Strings and characters:
syn region sqlString		start=+"+  skip=+\\\\\|\\"+  end=+"+
syn region sqlString		start=+'+  skip=+\\\\\|\\'+  end=+'+

" Numbers:
syn match sqlNumber		"-\=\<\d*\.\=[0-9_]\>"

" Comments:
syn region sqlComment    start="/\*"  end="\*/" contains=sqlTodo
syn match sqlComment	"--.*$" contains=sqlTodo

syn sync ccomment sqlComment

" Todo.
syn keyword sqlTodo contained TODO FIXME XXX DEBUG NOTE

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_sql_syn_inits")
  if version < 508
    let did_sql_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink sqlComment	Comment
  HiLink sqlKeyword	sqlSpecial
  HiLink sqlNumber	Number
  HiLink sqlOperator	sqlStatement
  HiLink sqlSpecial	Special
  HiLink sqlStatement	Statement
  HiLink sqlString	String
  HiLink sqlType	Type
  HiLink sqlTodo	Todo

  delcommand HiLink
endif

let b:current_syntax = "sql"

" vim: ts=8

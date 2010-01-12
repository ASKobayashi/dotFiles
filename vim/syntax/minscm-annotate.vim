"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
"=============================================================================

if exists("b:current_syntax")
  finish
endif

runtime! syntax/diff.vim

syn match minscmAnnotateInfo       "^[^|]*"
syn match minscmAnnotateSeparator  "|."
syn match minscmAnnotateLineNormal "||.*" contains=minscmAnnotateSeparator
syn match minscmAnnotateLineOld    "|-.*" contains=minscmAnnotateSeparator
syn match minscmAnnotateLineNew    "|+.*" contains=minscmAnnotateSeparator

" 
hi def link minscmAnnotateInfo       Statement
hi def link minscmAnnotateSeparator  Ignore
hi def link minscmAnnotateLineNormal Normal
hi def link minscmAnnotateLineOld    Special
hi def link minscmAnnotateLineNew    Identifier

let b:current_syntax = "minscm-annotate"

"=============================================================================
" vim: set fdm=marker:


"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
"=============================================================================

if exists("b:current_syntax")
  finish
endif

runtime! syntax/diff.vim

syn match minscmCommitComment        "^#.*"
syn match minscmCommitSummary        "^# SCM:.*"        contains=minscmCommitComment
syn match minscmCommitSummary        "^# Root:.*"       contains=minscmCommitComment
syn match minscmCommitSummary        "^# Branch:.*"     contains=minscmCommitComment
syn match minscmCommitStatus         "^# \[[^]]*].*"    contains=minscmCommitComment
syn match minscmCommitStatusNew      "^# \[New].*"      contains=minscmCommitComment
syn match minscmCommitStatusMissing  "^# \[Missing].*"  contains=minscmCommitComment
syn match minscmCommitStatusModified "^# \[Modified].*" contains=minscmCommitComment
syn match minscmCommitDiffNormal     "^#|.*"            contains=minscmCommitComment
syn match minscmCommitDiffRemoved    "^#|-.*"           contains=minscmCommitComment
syn match minscmCommitDiffAdded      "^#|+.*"           contains=minscmCommitComment
syn match minscmCommitDiffFile       "^#|diff.*"        contains=minscmCommitComment
syn match minscmCommitDiffFile       "^#|+++ .*"        contains=minscmCommitComment
syn match minscmCommitDiffFile       "^#|--- .*"        contains=minscmCommitComment
syn match minscmCommitDiffLine       "^#|@@.*"          contains=minscmCommitComment
syn match minscmCommitComment        "^#[ |]"           contained

" 
hi def link minscmCommitComment        Comment
hi def link minscmCommitSummary        Title
hi def link minscmCommitStatus         Constant
hi def link minscmCommitStatusNew      Identifier
hi def link minscmCommitStatusMissing  Special
hi def link minscmCommitStatusModified PreProc
hi def link minscmCommitDiffNormal     Normal
hi def link minscmCommitDiffFile       diffFile
hi def link minscmCommitDiffRemoved    diffRemoved
hi def link minscmCommitDiffAdded      diffAdded
hi def link minscmCommitDiffLine       diffLine

let b:current_syntax = "minscm-commit"

"=============================================================================
" vim: set fdm=marker:


"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
" GetLatestVimScripts: 2637 1 :AutoInstall: minscm.vim
"=============================================================================
" LOAD GUARD: {{{1

if exists('g:loaded_minscm') || v:version < 702
  finish
endif
let g:loaded_minscm = 1


" }}}1
"=============================================================================
" GLOBAL FUNCTION: {{{1

let s:statusReports = {}
"
function! g:minscm_getStatus()
  return minscm#getStatusReport(minscm#getTargetDir())
endfunction

" }}}1
"=============================================================================
" LOCAL FUNCTION: {{{1

"
function! s:getNames()
  return [
        \   'Command'      ,
        \   'CommitFile'   ,
        \   'CommitTracked',
        \   'CommitAll'    ,
        \   'Checkout'     ,
        \   'Merge'        ,
        \   'Branch'       ,
        \   'BranchDelete' ,
        \   'Rebase'       ,
        \   'DiffFile'     ,
        \   'DiffAll'      ,
        \   'Log'          ,
        \   'AnnotateFile' ,
        \   'Status'       ,
        \   'Grep'         ,
        \   'LoadModified' ,
        \   'LoadAll'      ,
        \   'FindFile'     ,
        \ ]
endfunction

"
function! s:initOptons()
  if !exists('g:minscm_availableScms')
    let g:minscm_availableScms = filter(['mercurial', 'git', 'bazaar'],
          \                             'minscm#{v:val}#isExecutable()')
  endif
  if !exists('g:minscm_mapLeader')
    let g:minscm_mapLeader = '\s'
  endif
  if !exists('g:minscm_mapLeaderAlternate')
    let g:minscm_mapLeaderAlternate = '\S'
  endif
  if !exists('g:minscm_mapKeyCommand')
    let g:minscm_mapKeyCommand = ':'
  endif
  if !exists('g:minscm_mapKeyCommitFile')
    let g:minscm_mapKeyCommitFile = 'C'
  endif
  if !exists('g:minscm_mapKeyCommitTracked')
    let g:minscm_mapKeyCommitTracked = '<C-c>'
  endif
  if !exists('g:minscm_mapKeyCommitAll')
    let g:minscm_mapKeyCommitAll = 'c'
  endif
  if !exists('g:minscm_mapKeyCheckout')
    let g:minscm_mapKeyCheckout = 'o'
  endif
  if !exists('g:minscm_mapKeyMerge')
    let g:minscm_mapKeyMerge = 'm'
  endif
  if !exists('g:minscm_mapKeyBranch')
    let g:minscm_mapKeyBranch = 'b'
  endif
  if !exists('g:minscm_mapKeyBranchDelete')
    let g:minscm_mapKeyBranchDelete = 'B'
  endif
  if !exists('g:minscm_mapKeyRebase')
    let g:minscm_mapKeyRebase = 'r'
  endif
  if !exists('g:minscm_mapKeyDiffFile')
    let g:minscm_mapKeyDiffFile = 'D'
  endif
  if !exists('g:minscm_mapKeyDiffAll')
    let g:minscm_mapKeyDiffAll = 'd'
  endif
  if !exists('g:minscm_mapKeyLog')
    let g:minscm_mapKeyLog = 'l'
  endif
  if !exists('g:minscm_mapKeyAnnotateFile')
    let g:minscm_mapKeyAnnotateFile = 'n'
  endif
  if !exists('g:minscm_mapKeyStatus')
    let g:minscm_mapKeyStatus = 's'
  endif
  if !exists('g:minscm_mapKeyGrep')
    let g:minscm_mapKeyGrep = 'g'
  endif
  if !exists('g:minscm_mapKeyLoadModified')
    let g:minscm_mapKeyLoadModified = '!'
  endif
  if !exists('g:minscm_mapKeyLoadAll')
    let g:minscm_mapKeyLoadAll = '<CR>'
  endif
  if !exists('g:minscm_mapKeyFindFile')
    let g:minscm_mapKeyFindFile = 'f'
  endif
  if !exists('g:minscm_hgLogOption')
    let g:minscm_hgLogOption = '-l1000 --style compact'
  endif
  if !exists('g:minscm_gitLogOption')
    let g:minscm_gitLogOption = '-1000 --all --graph --pretty=format:''%h (%ci) %s'''
  endif
  if !exists('g:minscm_bzrLogOption')
    let g:minscm_bzrLogOption = '-l1000 --line'
  endif
endfunction

"
function! s:initCommands()
  for name in s:getNames()
    execute printf('command! -bang %s call %s(%s)',
          \        'MinSCM' . name,
          \        'minscm#execute' . name,
          \        'len(<q-bang>), minscm#getTargetDir()')
  endfor
endfunction

"
function! s:initMappings()
  for [leader, bang] in [ [g:minscm_mapLeader, ''], [g:minscm_mapLeaderAlternate, '!'] ]
    execute printf('nnoremap <silent> %s      <Nop>', leader)
    execute printf('nnoremap <silent> %s<Esc> <Nop>', leader)
    for name in s:getNames()
      execute printf('nnoremap <silent> %s :%s%s<CR>',
            \        leader . g:minscm_mapKey{name},
            \        'MinSCM' . name,
            \        bang)
    endfor
  endfor
endfunction

"
function! s:initAutoCommands()
  augroup MinSCMGlobal
    autocmd!
    autocmd CursorHold   * call minscm#invalidateStatusReport(minscm#getTargetDir())
    autocmd CursorHoldI  * call minscm#invalidateStatusReport(minscm#getTargetDir())
    "autocmd BufWritePost * call minscm#invalidateStatusReport(minscm#getTargetDir())
  augroup END
endfunction

" }}}1
"=============================================================================
" INITIALIZATION: {{{1

call s:initOptons()
call s:initCommands()
call s:initMappings()
call s:initAutoCommands()

" }}}1
"=============================================================================
" vim: set fdm=marker:

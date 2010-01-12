"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
"=============================================================================
" PUBLIC: minscm#execute*: {{{1

"
function! minscm#executeCommand(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.command()
endfunction

"
function! minscm#executeCommitFile(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.commitFile()
endfunction

"
function! minscm#executeCommitTracked(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.commitTracked()
endfunction

"
function! minscm#executeCommitAll(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.commitAll()
endfunction

"
function! minscm#executeCheckout(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.checkout()
  call minscm#invalidateStatusReport(a:cwd)
endfunction

"
function! minscm#executeMerge(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.merge()
  call minscm#invalidateStatusReport(a:cwd)
endfunction

"
function! minscm#executeBranch(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.branch()
  call minscm#invalidateStatusReport(a:cwd)
endfunction

"
function! minscm#executeBranchDelete(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.branchDelete()
  call minscm#invalidateStatusReport(a:cwd)
endfunction

"
function! minscm#executeRebase(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(1)
    return
  endif
  call impl.rebase()
endfunction

"
function! minscm#executeDiffFile(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid()
    return
  endif
  call impl.diffFile()
endfunction

"
function! minscm#executeDiffAll(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.diffAll()
endfunction

"
function! minscm#executeLog(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid()
    return
  endif
  call impl.log()
endfunction

"
function! minscm#executeAnnotateFile(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid()
    return
  endif
  call impl.annotateFile()
endfunction

"
function! minscm#executeStatus(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.status()
endfunction

"
function! minscm#executeGrep(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.grep()
endfunction

"
function! minscm#executeLoadModified(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.loadModified()
endfunction

"
function! minscm#executeLoadAll(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.loadAll()
endfunction

"
function! minscm#executeFindFile(boolAlt, cwd)
  let impl = s:createImplementor(a:boolAlt, a:cwd, 1)
  if !impl.isValid() || !s:warnIfUnsavedBufferExist(0)
    return
  endif
  call impl.findFile()
endfunction

" }}}1
"=============================================================================
" PUBLIC: UTILITY FUNCTIONS: {{{1

" gets target file path associated with current buffer
function! minscm#getTargetFile()
  return (exists('b:minscm_targetFile') ? b:minscm_targetFile : expand('%:p'))
endfunction

"
function! minscm#getTargetDir()
  let file = minscm#getTargetFile()
  return (file =~ '\S' ? fnamemodify(file, ':h') : fnamemodify(getcwd(), ':p:h'))
endfunction

"
let s:statusReports = {}

"
function! minscm#getStatusReport(cwd)
  let dir = minscm#getTargetDir()
  if !exists('s:statusReports[a:cwd]')
    let impls = s:createAvailableImplementors(a:cwd)
    let s:statusReports[a:cwd] = join(map(impls, 'v:val.getStatusReport()'), ',')
  endif
  return s:statusReports[a:cwd]
endfunction

"
function! minscm#invalidateStatusReport(cwd)
  if exists('s:statusReports[a:cwd]')
    unlet s:statusReports[a:cwd]
  endif
endfunction

" echoes and save in the message-history.
function! minscm#echo(msg)
  call s:echoLinesHighlighting('None', s:makeMsgLines(a:msg), 0)
endfunction

" echoes and save in the message-history.
function! minscm#echoMessage(msg)
  call s:echoLinesHighlighting('None', s:makeMsgLines(a:msg), 1)
endfunction

" echoes and save in the message-history.
function! minscm#echoWarning(msg)
  call s:echoLinesHighlighting('WarningMsg', s:makeMsgLines(a:msg), 1)
endfunction

" echoes and save in the message-history.
function! minscm#echoError(msg)
  call s:echoLinesHighlighting('ErrorMsg', s:makeMsgLines(a:msg), 1)
endfunction

" if not found, returns ''
function! minscm#findParentDirIncludingDir(dirFrom, dirIncluded)
  let dir = fnamemodify(a:dirFrom, ':p') . '.'
  while dir != fnamemodify(dir, ':h')
    let dir = fnamemodify(dir, ':h')
    if isdirectory(fnamemodify(dir, ':p') . a:dirIncluded)
      return dir
    endif
  endwhile
  return ''
endfunction

"
function! minscm#modifyPathRelativeToDir(path, dir)
  let pathFull = fnamemodify(a:path, ':p')
  let dirFull = fnamemodify(a:dir, ':p')
  if len(pathFull) < len(dirFull) || pathFull[:len(dirFull) - 1] !=# dirFull
    return pathFull
  endif
  return pathFull[len(dirFull):]
endfunction

"
function! minscm#escapeForShell(str)
  return substitute(shellescape(a:str), "\\\\\n", "\n", "g")
endfunction

"
function minscm#makeQuickFixEntry(str, indexFile, indexLineNum, indexText, pathPrefix)
  let tokens = split(a:str, ':', 1)
  return  {
        \   'filename' : a:pathPrefix . tokens[a:indexFile],
        \   'lnum' : tokens[a:indexLineNum],
        \   'text' : join(tokens[a:indexText : ], ':'),
        \ }
endfunction

"
function! minscm#completeCmdline(lead, line, pos)
  return join(s:candidatesForCmdlineCompletion, "\n")
endfunction

" }}}1
"=============================================================================
" implementorBase: {{{1

let s:implementorBase = {}

"
function s:implementorBase.isValid()
  return 0
endfunction

"
function s:implementorBase.command()
  call minscm#echo('Command: ' . self.getRepositoryReport())
  let arg = s:inputHighlighting('Question', self.getCommandPrefix() . ' : ')
  if arg == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    call minscm#echoMessage(self.execute([arg]))
    call minscm#echoMessage('-- Command completed --')
    checktime
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Command failed')
  endtry
endfunction

"
function s:implementorBase.commitFile()
  call minscm#echo('CommitFile: ' . self.getRepositoryReport())
  let fileTarget = minscm#getTargetFile()
  if !filereadable(fileTarget)
    call minscm#echoError('Cannot read the file: ' . minscm#escapeForShell(fileTarget))
    return
  endif
  let statuses = self.getStatusesFile(fileTarget)
  if empty(statuses)
    call minscm#echo('No changes.')
    return
  endif
  try
    let linesDiff = self.getDiffFileLines(self.getRevisionParent(), fileTarget)
  catch
    let linesDiff = []
  endtry
  let lines = s:formatCommitBufferLines(
        \ self.getScmName(), self.dirRoot,
        \ self.getBranchCurrent(), statuses, linesDiff)
  call s:tempbuffer_launch(
        \ lines, self.formatTempBufferName('CommitFile'), 'minscm-commit',
        \ 1, self, 'onCloseForCommit', 'onWriteForCommitFile')
endfunction

"
function s:implementorBase.commitTracked()
  call minscm#echo('CommitTracked: ' . self.getRepositoryReport())
  let statuses = self.getStatusesTracked()
  if empty(statuses)
    call minscm#echo('No changes.')
    return
  endif
  try
    let linesDiff = self.getDiffAllLines(self.getRevisionParent())
  catch
    let linesDiff = []
  endtry
  let lines = s:formatCommitBufferLines(
        \ self.getScmName(), self.dirRoot,
        \ self.getBranchCurrent(), statuses, linesDiff)
  call s:tempbuffer_launch(
        \ lines, self.formatTempBufferName('CommitTracked'), 'minscm-commit',
        \ 1, self, 'onCloseForCommit', 'onWriteForCommitTracked')
endfunction

"
function s:implementorBase.commitAll()
  call minscm#echo('CommitAll: ' . self.getRepositoryReport())
  let statuses = self.getStatusesAll()
  if empty(statuses)
    call minscm#echo('No changes.')
    return
  endif
  try
    let linesDiff = self.getDiffAllLines(self.getRevisionParent())
  catch
    let linesDiff = []
  endtry
  let lines = s:formatCommitBufferLines(
        \ self.getScmName(), self.dirRoot,
        \ self.getBranchCurrent(), statuses, linesDiff)
  call s:tempbuffer_launch(
        \ lines, self.formatTempBufferName('CommitAll'), 'minscm-commit',
        \ 1, self, 'onCloseForCommit', 'onWriteForCommitAll')
endfunction

"
function s:implementorBase.onWriteForCommitFile(lines)
  let msg = join(filter(a:lines, 'v:val !~ "^#"'), "\n")
  if msg !~ '\S'
    call minscm#echoWarning('Enter commit massage')
    return 0
  endif
  try
    call self.executeCommitFile(msg, minscm#getTargetFile())
    call minscm#echoMessage('-- Commit completed --')
    call minscm#invalidateStatusReport(minscm#getTargetDir())
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Commit failed')
  endtry
  return 1
endfunction

"
function s:implementorBase.onWriteForCommitTracked(lines)
  let msg = join(filter(a:lines, 'v:val !~ "^#"'), "\n")
  if msg !~ '\S'
    call minscm#echoWarning('Enter commit massage')
    return 0
  endif
  try
    call self.executeCommitTracked(msg)
    call minscm#echoMessage('-- Commit completed --')
    call minscm#invalidateStatusReport(minscm#getTargetDir())
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Commit failed')
  endtry
  return 1
endfunction

"
function s:implementorBase.onWriteForCommitAll(lines)
  let msg = join(filter(a:lines, 'v:val !~ "^#"'), "\n")
  if msg !~ '\S'
    call minscm#echoWarning('Enter commit massage')
    return 0
  endif
  try
    call self.executeCommitAll(msg)
    call minscm#echoMessage('-- Commit completed --')
    call minscm#invalidateStatusReport(minscm#getTargetDir())
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Commit failed')
  endtry
  return 1
endfunction

"
function s:implementorBase.onCloseForCommit(boolWritten)
  if !a:boolWritten
    call minscm#echoWarning('Commit canceled')
  endif
endfunction

"
function s:implementorBase.checkout()
  call minscm#echo('Checkout: ' . self.getRepositoryReport())
  if !exists('self.executeCheckout')
    call minscm#echoError('This command is not supported.')
    return
  endif
  let revision = s:inputHighlighting('Question', 'Revision to checkout: ', self.getBranchDefault(), self.getRevisions())
  if revision == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    call self.executeCheckout(revision)
    call minscm#echoMessage('-- Checkout completed --')
    checktime
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Checkout failed')
  endtry
endfunction

"
function s:implementorBase.merge()
  call minscm#echo('Merge: ' . self.getRepositoryReport())
  if !exists('self.executeMerge')
    call minscm#echoError('This command is not supported.')
    return
  endif
  let revision = s:inputHighlighting('Question', 'Merge with: ', '', self.getBranchesNoncurrent())
  if revision == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    call self.executeMerge(revision)
    call minscm#echoMessage('-- Merge completed --')
    checktime
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Merge failed')
  endtry
endfunction

"
function s:implementorBase.branch()
  call minscm#echo('Branch: ' . self.getRepositoryReport())
  if !exists('self.executeBranch')
    call minscm#echoError('This command is not supported.')
    return
  endif
  let branch = s:inputHighlighting('Question', 'New branch name: ')
  if branch == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    call self.executeBranch(branch)
    call minscm#echoMessage('-- Branch completed --')
    checktime
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Branch failed')
  endtry
endfunction

"
function s:implementorBase.branchDelete()
  call minscm#echo('BranchDelete: ' . self.getRepositoryReport())
  if !exists('self.executeBranchDelete')
    call minscm#echoError('This command is not supported.')
    return
  endif
  let branch = s:inputHighlighting('Question', 'branch name to delete: ', '', self.getBranchesNoncurrent())
  if branch == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    call self.executeBranchDelete(branch)
    call minscm#echoMessage('-- BranchDelete completed --')
    checktime
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('BranchDelete failed')
  endtry
endfunction

"
function s:implementorBase.rebase()
  call minscm#echo('Rebase: ' . self.getRepositoryReport())
  if !exists('self.executeRebase')
    call minscm#echoError('This command is not supported.')
    return
  endif
  let branch = s:inputHighlighting('Question', 'Upstream revision: ', self.getBranchDefault(), self.getRevisions())
  if branch == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    call self.executeRebase(branch)
    call minscm#echoMessage('-- Rebase completed --')
    checktime
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('Rebase failed')
  endtry
endfunction

"
function s:implementorBase.diffFile()
  let fileTarget = minscm#getTargetFile()
  if !filereadable(fileTarget)
    call minscm#echoError('Cannot read the file: ' . minscm#escapeForShell(fileTarget))
    return
  endif
  call minscm#echo('DiffFile: ' . self.getRepositoryReport())
  let revision = s:inputHighlighting('Question', 'Compare with: ',
        \                            self.getRevisionParent(), self.getRevisions())
  if revision == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  try
    let lines = self.getCatFileLines(revision, fileTarget)
  catch /^MinSCM:execute:.*/
    call minscm#echoMessage(split(v:exception, "\n")[1:])
    call minscm#echoError('DiffFile failed')
    return
  endtry
  call s:openFileInNewTabpage(fileTarget)
  setlocal nowrap
  let filetype = &l:filetype
  let s:bufnrDiff = s:reopenTempBuffer((exists('s:bufnrDiff') ? s:bufnrDiff : -1), 1)
  call s:associateTargetFile(fileTarget)
  setlocal buflisted noswapfile nowrap bufhidden=delete buftype=nofile
  let &l:filetype = filetype
  silent file `=self.formatTempBufferName('DiffFile')`
  call setline(1, lines)
  diffthis
  wincmd p
  diffthis
endfunction

"
function s:implementorBase.diffAll()
  call minscm#echo('DiffAll: ' . self.getRepositoryReport())
  let revision = s:inputHighlighting('Question', 'Compare with: ',
        \                            self.getRevisionParent(), self.getRevisions())
  if revision == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  let lines = self.getDiffAllLines(revision)
  if len(lines) == 0
    call minscm#echo('No changes.')
    return
  endif
  call s:tempbuffer_launch(lines, self.formatTempBufferName('DiffAll'),
        \                  'diff', 0, self, '', '')
endfunction

"
function s:implementorBase.log()
  let lines = self.getLogLines()
  call s:tempbuffer_launch(lines, self.formatTempBufferName('Log'),
        \                  'minscm-log', 0, self, '', '')
endfunction

"
function s:implementorBase.annotateFile()
  let fileTarget = minscm#getTargetFile()
  if !filereadable(fileTarget)
    call minscm#echoError('Cannot read the file: ' . minscm#escapeForShell(fileTarget))
    return
  endif
  call minscm#echo('AnnotateFile: ' . self.getRepositoryReport())
  let revision = s:inputHighlighting('Question', 'Revision to annotate: ',
        \                            self.getRevisionParent(), self.getRevisions())
  if revision == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  let lines = self.getAnnotateFileLines(revision, fileTarget)
  call s:tempbuffer_launch(lines, self.formatTempBufferName('AnnotateFile'),
        \                  'minscm-annotate', 0, self, '', '')
endfunction

"
function s:implementorBase.status()
  call minscm#echo(['Status: ' . self.getRepositoryReport()] + self.getStatusesAll())
endfunction

"
function s:implementorBase.grep()
  call minscm#echo('Grep: ' . self.getRepositoryReport())
  if !exists('self.getGrepQuickFixes')
    call minscm#echoError('This command is not supported.')
    return
  endif
  let pattern = s:inputHighlighting('Question', 'Search pattern: ')
  if pattern == ''
    call minscm#echoWarning('Canceled')
    return
  endif
  call setqflist(self.getGrepQuickFixes(pattern))
  cope
endfunction

"
function s:implementorBase.loadModified()
  let files = self.getLsModified()
  call s:deleteAllBuffersExcept(files)
  call s:loadFiles(files)
endfunction

"
function s:implementorBase.loadAll()
  let files = self.getLsAll()
  call s:deleteAllBuffersExcept(files)
  call s:loadFiles(files)
endfunction

"
function s:implementorBase.findFile()
  call g:FuzzyFinderMode.GivenFile.launch('', 0, self.getLsAll())
endfunction

" throws "MinSCM:execute\n..." if shell command had an error.
function s:implementorBase.execute(args)
  let error = 0
  let cmd = join([self.getCommandPrefix()] + a:args, ' ')
  try
    let out = system(cmd)
  catch
    let error = 1
    let out = v:exception
  endtry
  if error || v:shell_error
    throw printf("MinSCM:execute: Command error (%d)\n%s\n%s", v:shell_error, cmd, out)
  endif
  return out
endfunction

"
function s:implementorBase.formatTempBufferName(cmd)
  return '[MinSCM-' . a:cmd . '-' . self.getScmName() . ']'
endfunction

"
function s:implementorBase.getBranchesNoncurrent()
  let branchCurrent = self.getBranchCurrent()
  return filter(self.getBranches(), 'v:val !=# branchCurrent')
endfunction

"
function s:implementorBase.getRepositoryReport()
  return printf('%s - %s - %s',
        \       self.getScmName(), self.dirRoot, self.getBranchCurrent())
endfunction

"
function s:implementorBase.getStatusReport()
  return self.getCommandName() . ':' . self.getBranchCurrent()
endfunction

" }}}1
"=============================================================================
" tempbuffer_*: {{{1

"
" a:impl[a:keyOnClose]: takes whether the buffer was written or not.
" a:impl[a:keyOnWrite]: takes all lines of the buffer. Return false if not completable.
function! s:tempbuffer_launch(lines, bufname, filetype, boolWritable, impl, keyOnClose, keyOnWrite)
  let fileTarget = minscm#getTargetFile()
  let s:tempbuffer_winnrPrev = winnr()
  let s:tempbuffer_bufnr = s:reopenTempBuffer((exists('s:tempbuffer_bufnr') ? s:tempbuffer_bufnr : -1), 0)
  let s:tempbuffer_winnr = winnr()
  let s:tempbuffer_fWritten = 0
  let s:tempbuffer_impl = a:impl
  let s:tempbuffer_keyOnClose = a:keyOnClose
  let s:tempbuffer_keyOnWrite = a:keyOnWrite
  call s:associateTargetFile(fileTarget)
  setlocal buflisted noswapfile nowrap bufhidden=delete
  let &l:filetype = a:filetype
  silent file `=a:bufname`
  call setline(1, a:lines)
  if a:boolWritable
    setlocal nomodified modifiable   noreadonly buftype=acwrite
  else
    setlocal nomodified nomodifiable readonly   buftype=nofile
  endif
  augroup TempBufferBase
    autocmd! * <buffer>
    autocmd BufDelete   <buffer> call s:tempbuffer_onBufDelete()
    autocmd BufWriteCmd <buffer> call s:tempbuffer_onBufWriteCmd()
  augroup END
endfunction

"
function! s:tempbuffer_onBufDelete()
  augroup TempBufferBase
    autocmd! * <buffer>
  augroup END
  if exists('s:tempbuffer_impl[s:tempbuffer_keyOnClose]')
    " NOTE: function() doesn't accept dictionary functions.
    call s:tempbuffer_impl[s:tempbuffer_keyOnClose](s:tempbuffer_fWritten)
  endif
  if winnr() == s:tempbuffer_winnr && winnr('$') >= s:tempbuffer_winnrPrev
    execute s:tempbuffer_winnrPrev . 'wincmd w'
  endif
endfunction

"
function! s:tempbuffer_onBufWriteCmd()
  if !exists('s:tempbuffer_impl[s:tempbuffer_keyOnWrite]') ||
        \ s:tempbuffer_impl[s:tempbuffer_keyOnWrite](getline(1, '$'))
    setlocal nomodified
    let s:tempbuffer_fWritten = 1
    execute printf('%dbdelete! ', s:tempbuffer_bufnr)
  endif
endfunction

" }}}1
"=============================================================================
" UTILITY FUNCTIONS: {{{1

"
function! s:escapeFilename(fn)
  return escape(a:fn, " \t\n*?[{`$%#'\"|!<")
endfunction

"
function! s:formatCommitBufferLines(nameScm, dirRoot, nameBranch, linesStatus, linesDiff)
  let s:TEXT_FORMAT_WIDTH = 78
  return  [''] +
        \ [ repeat('#', s:TEXT_FORMAT_WIDTH) ] +
        \ [ '# SCM: ' . a:nameScm ] +
        \ [ '# Root: ' . a:dirRoot ] +
        \ [ '# Branch: ' . a:nameBranch ] +
        \ map(a:linesStatus, '"# " . v:val') +
        \ [ repeat('#', s:TEXT_FORMAT_WIDTH) ] +
        \ map(a:linesDiff, '"#|" . v:val')
endfunction

" associates target file with current buffer
function! s:associateTargetFile(path)
  let b:minscm_targetFile = a:path
endfunction

"
function! s:makeMsgLines(msg)
  return map((type(a:msg) == type('') ? split(a:msg, "\n") : a:msg), '"[MinSCM] " . v:val')
endfunction

"
function! s:echoLinesHighlighting(hl, lines, boolAddHistory)
  let cmdEcho = (a:boolAddHistory ? 'echomsg' : 'echo')
  execute "echohl " . a:hl
  for l in a:lines
    execute cmdEcho . ' l'
  endfor
  echohl None
endfunction

"
function! s:inputHighlighting(hl, prompt, ...)
  execute "echohl " . a:hl
  if a:0 > 1
    let s:candidatesForCmdlineCompletion = a:2
    let s = input('[MinSCM] ' . a:prompt, a:1, 'custom,minscm#completeCmdline')
  elseif a:0 > 0
    let s = input('[MinSCM] ' . a:prompt, a:1)
  else
    let s = input('[MinSCM] ' . a:prompt)
  endif
  echohl None
  redraw " needed to show following echo in next line.
  return s
endfunction

"
function! s:openFileInNewTabpage(file)
  let bufnr = bufnr('^' . a:file . '$')
  if bufnr > -1
    execute ':tab :' . bufnr . 'sbuffer'
  else
    execute ':tabedit ' . s:escapeFilename(a:file)
  endif
endfunction

"
function! s:reopenTempBuffer(bufnr, boolVertical)
  let cmdVert = (a:boolVertical ? ':vertical ' : '')
  if !bufexists(a:bufnr)
    execute cmdVert . ':new'
    return bufnr('%')
  endif
  if buflisted(a:bufnr)
    execute printf('%dbdelete!', a:bufnr)
  endif
  execute printf('silent %s%dsbuffer', cmdVert, a:bufnr)
  return a:bufnr
endfunction

"
function! s:loadFiles(files)
  for file in filter(copy(a:files), 'filereadable(v:val) && !bufloaded(v:val)')
    execute 'edit ' . s:escapeFilename(file)
  endfor
endfunction

"
function! s:deleteAllBuffersExcept(files)
  let bufnrExcepts = map(copy(a:files), 'bufnr("^" . v:val . "$")')
  for bufnr in filter(range(1, bufnr('$')), 'bufloaded(v:val)')
    if len(filter(copy(bufnrExcepts), 'v:val == bufnr')) == 0
      execute bufnr . 'bdelete'
    endif
  endfor
endfunction

" 
function! s:createAvailableImplementors(cwd)
  return filter(map(copy(g:minscm_availableScms),
        \           'extend(copy(s:implementorBase), minscm#{v:val}#createImplementor(a:cwd))'),
        \       'v:val.isValid()')
endfunction


" 
function! s:createImplementor(boolAlt, cwd, boolEchoError)
  let impls = s:createAvailableImplementors(a:cwd)
  if !empty(impls)
    return impls[a:boolAlt ? -1 : 0]
  endif
  if a:boolEchoError
    call minscm#echoError('There is no available repository: ' . minscm#escapeForShell(a:cwd))
  endif
  return s:implementorBase
endfunction

"
function! s:isModifiedBuffer(bufnr)
  return buflisted(a:bufnr) && getbufvar(a:bufnr, '&modified')
endfunction

"
function! s:warnIfUnsavedBufferExist(boolAsk)
  if empty(filter(range(1, bufnr('$')), 's:isModifiedBuffer(v:val)'))
    return 1
  endif
  if !a:boolAsk
    call minscm#echoWarning('Unsaved buffers exist.')
    return 1
  endif
  return s:inputHighlighting('WarningMsg', "Unsaved buffers exist. Continue? (Y/N) :") ==? 'Y'
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
"=============================================================================
" PUBLIC: {{{1

" if a:cwd is not in repository, returns {}
function! minscm#mercurial#createImplementor(cwd)
  let impl = copy(s:implementor)
  let impl.dirRoot =  minscm#findParentDirIncludingDir(a:cwd, '.hg')
  return (impl.dirRoot == '' ? {} : impl)
endfunction

"
function! minscm#mercurial#isExecutable()
  return executable(s:implementor.getCommandName())
endfunction

" }}}1
"=============================================================================
" implementor: {{{1

let s:implementor = {}

"
function s:implementor.isValid()
  return 1
endfunction

"
function s:implementor.executeCommitFile(msg, file)
  call minscm#echoMessage(self.execute(['commit -v -m', minscm#escapeForShell(a:msg), minscm#escapeForShell(a:file)]))
endfunction

"
function s:implementor.executeCommitTracked(msg)
  call minscm#echoMessage(self.execute(['commit -v -m', minscm#escapeForShell(a:msg)]))
endfunction

"
function s:implementor.executeCommitAll(msg)
  call minscm#echoMessage(self.execute(['commit -v -m', minscm#escapeForShell(a:msg), '-A']))
endfunction

"
function s:implementor.executeCheckout(revision)
  call minscm#echoMessage(self.execute(['update -v -r', minscm#escapeForShell(a:revision)]))
endfunction

"
function s:implementor.executeMerge(revision)
  call minscm#echoMessage(self.execute(['merge -v -r', minscm#escapeForShell(a:revision)]))
endfunction

"
function s:implementor.executeBranch(branch)
  call minscm#echoMessage(self.execute(['branch -v', minscm#escapeForShell(a:branch)]))
endfunction

"
"function s:implementor.executeBranchDelete(branch)
"endfunction

"
function s:implementor.executeRebase(branch)
  call minscm#echoMessage(self.execute(['rebase -v --keep -b', minscm#escapeForShell(a:branch)]))
endfunction

"
function s:implementor.getCommandPrefix()
  return 'hg --cwd ' . minscm#escapeForShell(self.dirRoot)
endfunction

"
function s:implementor.getCatFileLines(revision, file)
  return split(self.execute(['cat -r', minscm#escapeForShell(a:revision), minscm#escapeForShell(a:file)]), "\n")
endfunction

"
function s:implementor.getTags()
  return map(split(self.execute(['tags']), "\n"), 'matchstr(v:val, ''^\S*'')')
endfunction

"
function s:implementor.getBranchCurrent()
  return matchstr(self.execute(['branch']), "^[^\n]*")
endfunction

"
function s:implementor.getBranches()
  return map(split(self.execute(['branches -a']), "\n"), 'matchstr(v:val, ''^\S*'')')
endfunction

"
function s:implementor.getDiffFileLines(revision, file)
  return split(self.execute(['diff -r', minscm#escapeForShell(a:revision), a:file]), "\n")
endfunction

"
function s:implementor.getDiffAllLines(revision)
  return split(self.execute(['diff -r', minscm#escapeForShell(a:revision)]), "\n")
endfunction

"
function s:implementor.getLogLines()
  try
    return split(self.execute(['glog', g:minscm_hgLogOption]), "\n")
  catch /^MinSCM:execute:.*/
    return ['(To show a revision graph, enable graphlog extension.)', ''] +
          \ split(self.execute(['log', g:minscm_hgLogOption]), "\n")
  endtry
endfunction

"
function s:implementor.getAnnotateFileLines(revision, file)
  let revNormal = self.normalizeRevision(a:revision)
  " NOTE: -f option shows filename.
  let cmds = ['annotate -nudq -r', revNormal,
        \     minscm#escapeForShell(a:file)]
  return map(split(self.execute(cmds), "\n"),
        \    's:formatAnnotateLine(v:val, revNormal)')
endfunction

"
function s:implementor.getStatusesFile(file)
  let cmds = ['status', minscm#escapeForShell(a:file)]
  return map(split(self.execute(cmds), "\n"), 's:formatStatusLine(v:val)')
endfunction

"
function s:implementor.getStatusesTracked()
  return map(split(self.execute(['status -mar']), "\n"), 's:formatStatusLine(v:val)')
endfunction

"
function s:implementor.getStatusesAll()
  return map(split(self.execute(['status']), "\n"), 's:formatStatusLine(v:val)')
endfunction

"
function s:implementor.getGrepQuickFixes(pattern)
  try
    let pathPrefix = fnamemodify(self.dirRoot, ":p:.")
    let cmds = ['grep -n', minscm#escapeForShell(a:pattern)]
    return map(split(self.execute(cmds), "\n"),
          \    'minscm#makeQuickFixEntry(v:val, 0, 2, 3, pathPrefix)')
  catch /^MinSCM:execute:.*/
    " if matching lines are not found, shell status isn't zero.
    if len(split(v:exception, "\n")) > 2
      throw v:exception
    endif
    return []
  endtry
endfunction

"
function s:implementor.getLsModified()
  return map(split(self.execute(['status -mn']), "\n"),
        \    'fnamemodify(self.dirRoot, ":p") . v:val')
endfunction

"
function s:implementor.getLsAll()
  return split(self.execute(['locate -f']), "\n")
endfunction

"
function s:implementor.getScmName()
  return 'Mercurial'
endfunction

"
function s:implementor.getCommandName()
  return 'hg'
endfunction

"
function s:implementor.getRevisionParent()
  return '.'
endfunction

"
function s:implementor.getRevisions()
  return ['.', 'null',] + self.getTags() + self.getBranches()
endfunction

"
function s:implementor.normalizeRevision(revision)
  return self.execute(['log --template "{rev}" -r',
        \              minscm#escapeForShell(a:revision)])
endfunction

"
function s:implementor.getBranchDefault()
  return 'default'
endfunction

" }}}1
"=============================================================================
" UTILITY FUNCTIONS: {{{1

"
function! s:formatStatusLine(line)
  for [pattern, subst] in [
        \   ['^?\s\+', '[New]      '],
        \   ['^!\s\+', '[Missing]  '],
        \   ['^M\s\+', '[Modified] '],
        \   ['^A\s\+', '[Added]    '],
        \   ['^R\s\+', '[Removed]  '],
        \   ['^C\s\+', '[Clean]    '],
        \   ['^I\s\+', '[Ignored]  '],
        \ ]
    if a:line =~# pattern
      return substitute(a:line, pattern, subst, 'g')
    endif
  endfor
  return a:line
endfunction

"
function! s:formatAnnotateLine(line, revNew)
  let strDst = '||'
  if a:line =~ '\<0\s\+\d\d\d\d-\d\d-\d\d:'
    let strDst = '|-'
  elseif matchstr(a:line, '\<\d\+\ze\s\+\d\d\d\d-\d\d-\d\d:') == a:revNew
    let strDst = '|+'
  endif
  return substitute(a:line, ': ', strDst, '')
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
"=============================================================================
" PUBLIC: {{{1

" if a:cwd is not in repository, returns {}
function! minscm#git#createImplementor(cwd)
  let impl = copy(s:implementor)
  let impl.dirRoot =  minscm#findParentDirIncludingDir(a:cwd, '.git')
  return (impl.dirRoot == '' ? {} : impl)
endfunction

"
function! minscm#git#isExecutable()
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
  call minscm#echoMessage(self.execute(['commit -m', minscm#escapeForShell(a:msg), minscm#escapeForShell(a:file)]))
endfunction

"
function s:implementor.executeCommitTracked(msg)
  call minscm#echoMessage(self.execute(['commit -m', minscm#escapeForShell(a:msg), '-a']))
endfunction

"
function s:implementor.executeCommitAll(msg)
  call minscm#echoMessage(self.execute(['add -v -A']))
  call self.executeCommitTracked(a:msg)
endfunction

"
function s:implementor.executeCheckout(revision)
  call minscm#echoMessage(self.execute(['checkout', minscm#escapeForShell(a:revision)]))
endfunction

"
function s:implementor.executeMerge(revision)
  call minscm#echoMessage(self.execute(['merge', minscm#escapeForShell(a:revision)]))
endfunction

"
function s:implementor.executeBranch(branch)
  call minscm#echoMessage(self.execute(['checkout -b', minscm#escapeForShell(a:branch)]))
endfunction

"
function s:implementor.executeBranchDelete(branch)
  call minscm#echoMessage(self.execute(['branch -d', minscm#escapeForShell(a:branch)]))
endfunction

"
function s:implementor.executeRebase(branch)
  call minscm#echoMessage(self.execute(['rebase', minscm#escapeForShell(a:branch)]))
endfunction

"
function s:implementor.getCommandPrefix()
  return 'cd ' . minscm#escapeForShell(self.dirRoot) . ' && git --no-pager'
endfunction

"
function s:implementor.getCatFileLines(revision, file)
  let optObj = a:revision . ':' .
        \ minscm#escapeForShell(minscm#modifyPathRelativeToDir(a:file, self.dirRoot))
  return split(self.execute(['cat-file -p', optObj]), "\n")
endfunction

"
function s:implementor.getTags()
  return map(split(self.execute(['tag']), "\n"), 'v:val')
endfunction

"
function s:implementor.getBranchCurrent()
  let curBranches = filter(split(self.execute(['branch']), "\n"), 'v:val =~ ''^*''')
  if empty(curBranches)
    return '(?)'
  endif
  return matchstr(curBranches[0], '^\*\s*\zs.*$')
endfunction

"
function s:implementor.getBranches()
  return map(split(self.execute(['branch']), "\n"), 'matchstr(v:val, ''^\*\?\s*\zs.*$'')')
endfunction

"
function s:implementor.getDiffFileLines(revision, file)
  let cmds = ['diff', minscm#escapeForShell(a:revision),
        \     '--', minscm#escapeForShell(a:file)]
  return split(self.execute(cmds), "\n")
endfunction

"
function s:implementor.getDiffAllLines(revision)
  let cmds = ['diff', minscm#escapeForShell(a:revision)]
  return split(self.execute(cmds), "\n")
endfunction

"
function s:implementor.getLogLines()
  return split(self.execute(['log', g:minscm_gitLogOption]), "\n")
endfunction

"
function s:implementor.getAnnotateFileLines(revision, file)
  let revNormal = self.normalizeRevision(a:revision)
  let cmds = ['blame', revNormal,
        \     '--', minscm#escapeForShell(a:file)]
  return map(split(self.execute(cmds), "\n"),
        \    's:formatAnnotateLine(v:val, revNormal)')
endfunction

"
function s:implementor.getStatusesFile(file)
  return  map(split(self.execute(['diff --name-status HEAD --', minscm#escapeForShell(a:file)]), "\n"),
        \     's:formatStatusLine(v:val)') +
        \ map(split(self.execute(['ls-files --exclude-standard -o --', minscm#escapeForShell(a:file)]), "\n"),
        \     's:formatStatusLine("?\t" . v:val)')
endfunction

"
function s:implementor.getStatusesTracked()
  try
    return map(split(self.execute(['diff --name-status HEAD']), "\n"),
          \    's:formatStatusLine(v:val)')
  catch /^MinSCM:execute:.*/
    " There are no tracked files.
    return []
  endtry
endfunction

"
function s:implementor.getStatusesAll()
  return self.getStatusesTracked() +
        \ map(split(self.execute(['ls-files --exclude-standard -o']), "\n"),
        \     's:formatStatusLine("?\t" . v:val)')
endfunction

"
function s:implementor.getGrepQuickFixes(pattern)
  try
    let pathPrefix = fnamemodify(self.dirRoot, ":p:.")
    let cmds = ['grep -n -e', minscm#escapeForShell(a:pattern)]
    return map(split(self.execute(cmds), "\n"),
          \    'minscm#makeQuickFixEntry(v:val, 0, 1, 2, pathPrefix)')
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
  return map(split(self.execute(['ls-files -m']), "\n"),
        \    'fnamemodify(self.dirRoot, ":p") . v:val')
endfunction

"
function s:implementor.getLsAll()
  return map(split(self.execute(['ls-files']), "\n"),
        \    'fnamemodify(self.dirRoot, ":p") . v:val')
endfunction

"
function s:implementor.getScmName()
  return 'Git'
endfunction

"
function s:implementor.getCommandName()
  return 'git'
endfunction

"
function s:implementor.getRevisionParent()
  return 'HEAD'
endfunction

"
function s:implementor.getRevisions()
  return ['HEAD', ] + self.getTags() + self.getBranches()
endfunction

"
function s:implementor.normalizeRevision(revision)
  return matchstr(self.execute(
        \ ['log --pretty=format:%H -1',
        \  minscm#escapeForShell(a:revision)]), '^\x\+')
endfunction

"
function s:implementor.getBranchDefault()
  return 'master'
endfunction

" }}}1
"=============================================================================
" UTILITY FUNCTIONS: {{{1

"
function! s:formatStatusLine(line)
  for [pattern, subst] in [
        \   ['^?\s\+', '[New]      '],
        \   ['^D\s\+', '[Missing]  '],
        \   ['^M\s\+', '[Modified] '],
        \   ['^A\s\+', '[Added]    '],
        \   ['^C\s\+', '[Copied]   '],
        \   ['^R\s\+', '[Renamed]  '],
        \   ['^T\s\+', '[Changed]  '],
        \   ['^U\s\+', '[Unmerged] '],
        \   ['^X\s\+', '[Unknown]  '],
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
  if a:line =~ '^\^'
    let strDst = '|-'
  elseif s:isPrefixMatching(matchstr(a:line, '^\S\+'), a:revNew)
    let strDst = '|+'
  endif
  return substitute(a:line, ')\zs ', strDst, '')
endfunction

"
function! s:isPrefixMatching(s0, s1)
  let pos = min([len(a:s0), len(a:s1)]) - 1
  return a:s0[: pos] == a:s1[: pos]
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

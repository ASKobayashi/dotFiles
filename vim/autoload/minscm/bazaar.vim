"=============================================================================
" Copyright (c) 2009 Takeshi NISHIDA
"
"=============================================================================
" PUBLIC: {{{1

" if a:cwd is not in repository, returns {}
function! minscm#bazaar#createImplementor(cwd)
  let impl = copy(s:implementor)
  let impl.dirRoot =  minscm#findParentDirIncludingDir(a:cwd, '.bzr')
  return (impl.dirRoot == '' ? {} : impl)
endfunction

"
function! minscm#bazaar#isExecutable()
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
  call minscm#echoMessage(self.execute(['add -v']))
  call self.executeCommitTracked(a:msg)
endfunction

"
"function s:implementor.executeCheckout(revision)
"endfunction

"
"function s:implementor.executeMerge(revision)
"endfunction

"
"function s:implementor.executeBranch(branch)
"endfunction

"
"function s:implementor.executeBranchDelete(branch)
"endfunction

"
"function s:implementor.executeRebase(branch)
"endfunction

"
function s:implementor.getCommandPrefix()
  return 'cd ' . minscm#escapeForShell(self.dirRoot) . ' && bzr'
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
  return ''
endfunction

"
function s:implementor.getBranches()
  return []
endfunction

"
function s:implementor.getDiffFileLines(revision, file)
  try
    return split(self.execute(['diff -r', minscm#escapeForShell(a:revision), a:file]), "\n")
  catch /^MinSCM:execute:.*/
    if v:shell_error != 1
      throw v:exception
    endif
    return split(v:exception, "\n")[2:]
  endtry
endfunction

"
function s:implementor.getDiffAllLines(revision)
  try
    return split(self.execute(['diff -r', minscm#escapeForShell(a:revision)]), "\n")
  catch /^MinSCM:execute:.*/
    if v:shell_error != 1
      throw v:exception
    endif
    return split(v:exception, "\n")[2:]
  endtry
endfunction

"
function s:implementor.getLogLines()
  return split(self.execute(['log', g:minscm_bzrLogOption]), "\n")
endfunction

"
function s:implementor.getAnnotateFileLines(revision, file)
  let revNormal = self.normalizeRevision(a:revision)
  let cmds = ['annotate --all --long -r', revNormal,
        \     minscm#escapeForShell(a:file)]
  return map(split(self.execute(cmds), "\n"),
        \    's:formatAnnotateLine(v:val, revNormal)')
endfunction

"
function s:implementor.getStatusesFile(file)
  return map(split(self.execute(['status -S', minscm#escapeForShell(a:file)]), "\n"), 's:formatStatusLine(v:val)')
endfunction

"
function s:implementor.getStatusesTracked()
  return map(split(self.execute(['status -SV']), "\n"), 's:formatStatusLine(v:val)')
endfunction

"
function s:implementor.getStatusesAll()
  return map(split(self.execute(['status -S']), "\n"), 's:formatStatusLine(v:val)')
endfunction

"
"function s:implementor.getGrepQuickFixes(pattern)
"endfunction

"
function s:implementor.getLsAll()
  return map(split(self.execute(['ls -V --from-root']), "\n"),
        \    'fnamemodify(self.dirRoot, ":p") . v:val')
endfunction

"
function s:implementor.getLsModified()
  let files = map(filter(split(self.execute(['status -SV']), "\n"),
        \                'v:val =~ ''^\s*M'''),
        \         'matchstr(v:val, ''^\s*M\s*\zs.*'')')
  return map(files, 'fnamemodify(self.dirRoot, ":p") . v:val')
endfunction

"
function s:implementor.getScmName()
  return 'Bazaar'
endfunction

"
function s:implementor.getCommandName()
  return 'bzr'
endfunction

"
function s:implementor.getRevisionParent()
  return '-1'
endfunction

"
function s:implementor.getRevisions()
  return  ['revno:', 'revid:', 'last:', 'before:', 'date:', 'ancestor:', 'branch:', 'submit:'] +
        \ map(self.getTags(), '"tag:" . v:val')
endfunction

"
function s:implementor.normalizeRevision(revision)
  return matchstr(self.execute(
        \ ['log --line -r', minscm#escapeForShell(a:revision)]), '^\d\+')
endfunction

"
function s:implementor.getBranchDefault()
  return ''
endfunction

" }}}1
"=============================================================================
" UTILITY FUNCTIONS: {{{1

"
function! s:formatStatusLine(line)
  for [pattern, subst] in [
        \   ['^?..\s\+', '[New]      '],
        \   ['^.D.\s\+', '[Missing]  '],
        \   ['^.M.\s\+', '[Modified] '],
        \   ['^.N.\s\+', '[Added]    '],
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
  if     a:line =~ '^1 '
    let strDst = '|-'
  elseif matchstr(a:line, '^\d\+') == a:revNew
    let strDst = '|+'
  endif
  return substitute(a:line, ' | ', strDst, '')
endfunction

" }}}1
"=============================================================================
" vim: set fdm=marker:

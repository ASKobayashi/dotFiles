" Make Control-direction switch between windows (like C-W h, etc)
" You must first run this command to reclaim the cmd-h command
" defaults write org.vim.MacVim NSUserKeyEquivalents -dict-add "Hide MacVim" "@\$H"

" Unbind Keys
if has("mac")
  macm File.New\ Tab key=<nop>
  macm Tools.List\ Errors key=<nop>
endif




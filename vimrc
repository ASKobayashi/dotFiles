" ASKobayashi's .vimrc

set nocompatible

" General Config
" =============================================================

syntax on

set incsearch         " find the next match as we type the search
set hlsearch          " hilight searches by default
set ignorecase        " ignores case, duh
set smartcase         " search in smart ways
set nowrap            " by default, dont wrap lines (see <leader>w)
set showmatch         " show matching brackets
set nostartofline     " don't jump to start of line as a side effect (i.e. <<)

" indenting
set expandtab         " use spaces instead of tabstops
set smarttab          " use shiftwidth when hitting tab instead of sts (?)
set autoindent        " try to put the right amount of space at the beginning of a new line
set expandtab         " In Insert mode: Use the appropriate number of spaces to insert a <Tab>
set tabstop=3         " number of spaces a tab represents
set shiftwidth=3      " Number of spaces to use for each step of (auto)indent.
set softtabstop=3     " Number of spaces that a <Tab> counts for while performing editing

set scrolloff=5       " lines to keep visible before and after cursor
set sidescrolloff=7   " columns to keep visible before and after cursor
set sidescroll=1      " continuous horizontal scroll rather than jumpy

set laststatus=2      " always display status line even if only one window is visible.
set updatetime=1000   " reduce updatetime so current tag in taglist is highlighted faster
set autoread          " suppress warnings when git,etc. changes files on disk.
set autowrite         " write buffers before invoking :make, :grep etc.
set nrformats=alpha,hex " C-A/C-X works on dec, hex, and chars (not octal so no leading 0 ambiguity)
set backspace=indent,eol,start "allow backspacing over everything in insert mode

set wildmode=list:longest,list:full   "make cmdline tab completion similar to bash
set wildmenu                          "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~,.git,.svn,*.rbc,*.class

set history=1000               "store lots of :cmdline history

set hidden          " allow buffers to go into the background without needing to save

let g:is_posix = 1  " vim's default is archaic bourne shell, bring it up to the 90s.

set visualbell      " don't beep constantly, it's annoying.
set t_vb=           " and don't flash the screen either (terminal anyway...
set guioptions-=T   " hide gvim's toolbar by default

" search for a tags file recursively from cwd to /
set tags=.tags,tags;/

" Store swapfiles in a single directory.
set directory=~/.vim/swap,~/tmp,/var/tmp/,tmp

" Set spell check diectionary to English US.
set spelllang=en_us


" Keymapping
" =============================================================

" Cmd h and l for first and last of line
nmap <C-h> ^
nmap <C-l> $

" Cmd j and k for next and previous screen scroll
nmap <C-j> <kPageDown>
nmap <C-k> <kPageUp>

" Make Control-direction switch between windows (like C-W h, etc)
" If it's not working look in .gvimrc for details
nmap <silent> <D-k> :wincmd k<CR>
nmap <silent> <D-j> :wincmd j<CR>
nmap <silent> <D-h> :wincmd h<CR>
nmap <silent> <D-l> :wincmd l<CR>

" Tag Bindings
map <C-D-.> <C-]>
map <C-D-,> <C-t>

" make Y yank to the end of the line (like C and D).  Use yy to yank the entire line.
nmap Y y$

" make ' jump to saved line & column rather than just line.
nnoremap ' `
nnoremap ` '

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" move forward and backward buffers
map <C-D-left>  :bp<cr>
map <C-D-right> :bn<cr>
" quicker to navigate the error window, just control-n, control-p
nmap <silent> <C-n> :lnext<CR>
nmap <silent> <C-p> :lprevious<CR>

" open the vimrc file in a new tab.
nmap <leader>v :tabedit $MYVIMRC<CR>

" Show syntax highlighting groups for word under cursor
nmap <C-S-y> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Plugins
" =============================================================
runtime macros/matchit.vim  " enable vim's built-in matchit script (make % bounce between tags, begin/end, etc)

" Setting up Vundle - script credit: http://www.erikzaadi.com/
   let iCanHazVundle=1
   let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
   if !filereadable(vundle_readme)
      echo "Installing Vundle.."
      echo ""
      silent !mkdir -p ~/.vim/bundle
      silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
      let iCanHazVundle=0
   endif

   set rtp+=~/.vim/bundle/vundle/
   call vundle#rc()
   Bundle 'gmarik/vundle'

   " File Browsing:
      " Graphical File Browsing
      Bundle 'https://github.com/scrooloose/nerdtree'
         nmap <D-d> :NERDTreeToggle<cr>
         nmap <leader>D :NERDTreeFind<cr>

      " File Search
      Bundle 'git://git.wincent.com/command-t.git'
         let g:CommandTMaxHeight=20
         map <D-t> :CommandT<CR>

   " Programming:
      " Syntax Checking
      Bundle 'https://github.com/scrooloose/syntastic/'

      " Code Searching
      Bundle 'https://github.com/vim-scripts/cscope.vim'

      " Code Browsing
      Bundle 'https://github.com/majutsushi/tagbar'
         nmap <leader>l :TagbarToggle<cr>
         " Open on supported file opens
         autocmd VimEnter * nested :call tagbar#autoopen(1)

      " Header <-> Source
      Bundle 'https://github.com/vim-scripts/a.vim'
         map <C-D-up> :A<CR>

      " Quick Commenting
      Bundle 'https://github.com/scrooloose/nerdcommenter'
         map <D-/> <plug>NERDCommenterToggle<CR>
         nmap <leader>/ <plug>NERDCommenterToggle<CR>
         " Without the following patch, there is no default align, which
         " Makes block comments look bad:
         " git pull https://github.com/ervandew/nerdcommenter.git master
         let NERDDefaultAlign = 'both'


      " Keeps ctags up to date
      Bundle 'https://github.com/vim-scripts/AutoTag'

      " Tab completion
      Bundle 'https://github.com/ervandew/supertab'
      let g:SuperTabMappingForward = '<c-space>'
      let g:SuperTabMappingBackward = '<s-c-space>'


      " Code Completion
      Bundle 'https://github.com/Rip-Rip/clang_complete'
      let g:clang_use_library = 1

      " Function Completion
      Bundle 'https://github.com/mbbill/echofunc'
      Bundle 'https://github.com/mbbill/code_complete'

      " Cscope
      if has("cscope")
         " add any cscope database in current directory
         if filereadable("cscope.out")
            cs add cscope.out
            " else add the database pointed to by environment variable
         elseif $CSCOPE_DB != ""
            cs add $CSCOPE_DB
         endif

         " show msg when any other cscope db added
         set cscopeverbose

         " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
         set cscopetag
         set csto=0

         " quickfix setup
         set cscopequickfix=s-,g-,c-,t-,d-,i-,t-,e-

         " Automatically open the quickfix
         autocmd QuickFixCmdPost [^l]* nested cwindow
         autocmd QuickFixCmdPost    l* nested lwindow

         " Open at the bottom
         autocmd FileType qf wincmd J

         " 's' symbol: find all references to the token under cursor
         " 'g' global: find global definition(s) of the token under cursor
         " 'c' calls:  find all calls to the function name under cursor
         " 't' text:   find all instances of the text under cursor
         " 'e' egrep:  egrep search for the word under cursor
         " 'f' file:   open the filename under cursor
         " 'i' includes: find files that include the filename under cursor
         " 'd' called: find functions that function under cursor calls
         nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
         nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
         nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
         nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
         nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
         nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
         nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
         nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

         " Convienient
         map <D-C->> :cs find c <C-R>=expand("<cword>")<CR><CR>
      endif


   " Beautifying:
      " Alignment
      Bundle 'https://github.com/godlygeek/tabular'
         " Running :Tab /= aligns everything to the = sign
         nmap <Leader>a= :Tabularize /[><!=]*=<CR>
         vmap <Leader>a= :Tabularize /[><!=]*=<CR>
         vmap <Leader>a/ :Tabularize /\/[\*\/]<CR>
         vmap <Leader>a/ :Tabularize /\/[\*\/]<CR>
         nmap <Leader>a: :Tabularize /:\zs<CR>
         vmap <Leader>a: :Tabularize /:\zs<CR>
         nmap <Leader>a, :Tabularize /,\zs<CR>
         vmap <Leader>a, :Tabularize /,\zs<CR>
         nmap <Leader>a" :Tabularize /"<CR>
         vmap <Leader>a" :Tabularize /"<CR>
         nmap <Leader>a' :Tabularize /"<CR>
         vmap <Leader>a' :Tabularize /"<CR>


   " Syntax Files:
      Bundle 'https://github.com/tpope/vim-git'
      Bundle 'https://github.com/tpope/vim-haml'
      Bundle 'https://github.com/gmarik/vim-markdown'
      Bundle 'svg.vim'
      Bundle 'xml.vim'


   " Color Schemes:
      Bundle 'https://github.com/tpope/vim-vividchalk'
      Bundle 'https://github.com/vim-scripts/Lucius'

      colorscheme torte

      " Less obnoxious PMenu colors
      hi Pmenu          ctermfg=255 ctermbg=238 guifg=#ffffff guibg=#444444
      hi PmenuSel       ctermfg=0 ctermbg=148 guifg=#000000 guibg=#b1d631
      hi PmenuSbar      ctermbg=7 guibg=Grey
      hi PmenuThumb     ctermbg=15 guibg=White

   if iCanHazVundle == 0
      echo "Installing Bundles, please ignore key map error messages"
      echo ""
      :BundleInstall
   endif
" Setting up Vundle - the vim plugin bundler end


" AUTO COMMANDS
" ==========================================================================================

if has("autocmd")

  " Automatically strip trailing white spaces.
  au BufWritePre * :%s/\s\+$//e

  " Remember last location in file
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif

  " load the plugin and indent settings for the detected filetype
  filetype plugin indent on

  " Syntax of these languages is fussy over tabs Vs spaces
  au FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Treat .rss files as XML
  au BufNewFile,BufRead *.rss setfiletype xml

  " add json syntax highlighting
  au BufNewFile,BufRead *.json set ft=javascript

  " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}	 set ft=ruby

endif

" Statusbar
" =============================================================

" line number config
set number            " turn on line numbers
set ruler             " always show current position
set noshowmode
set showcmd           " show incomplete cmds down the bottom

function! SetStatus()
  setl statusline+=
        \%*\ %f
        \%H%M%R%W%*\ ┃
        \%*\ %Y\ <<<\ %{&ff}%*
endfunction

function! SetRightStatus()
  setl statusline+=
        \%=%<%*
        \%*\ %l,%c\ >>>\ %P
endfunction " }}}

" Update when leaving Buffer {{{
function! SetStatusLeaveBuffer()
  setl statusline=""
  call SetStatus()
endfunction
au BufLeave * call SetStatusLeaveBuffer() " }}}

" Update when switching mode {{{
function! SetStatusInsertMode(mode)
  setl statusline=%*
  if a:mode == 'i'
    setl statusline+=insert\ ┃
  elseif a:mode == 'r'
    setl statusline+=replace\ ┃
  elseif a:mode == 'normal'
  endif
  call SetStatus()
  call SetRightStatus()
endfunction

au VimEnter     * call SetStatusInsertMode('normal')
au InsertEnter  * call SetStatusInsertMode(v:insertmode)
au InsertLeave  * call SetStatusInsertMode('normal')
au BufEnter     * call SetStatusInsertMode('normal')


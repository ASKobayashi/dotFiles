" ASKobayashi's .vimrc
set nocompatible      " Make vim behave in a more useful way

" General Config
" =============================================================

syntax on

" Display
set nowrap            " by default, dont wrap lines (see <leader>w)
set showmatch         " show matching brackets

" Search
set incsearch         " find the next match as we type the search
set hlsearch          " hilight searches by default
set ignorecase        " ignores case, duh
set smartcase         " Override ignorecase if search includes uppercase

" Indenting
set tabstop=4         " number of spaces a tab represents
set shiftwidth=4      " Number of spaces to use for each step of (auto)indent.
set softtabstop=4     " Number of spaces that a <Tab> counts for while performing editing
set autoindent        " try to put the right amount of space at the beginning of a new line
set noexpandtab       " Use tabs
set smarttab          " use shiftwidth when hitting tab instead of sts (?)
set nostartofline     " don't jump to start of line as a side effect (i.e. <<)

" Scroll & Mouse
set scrolloff=5       " lines to keep visible before and after cursor
set sidescrolloff=7   " columns to keep visible before and after cursor
set sidescroll=1      " continuous horizontal scroll rather than jumpy

if has("mouse")
   set mouse=a        " use mouse in all modes
   set ttymouse=xterm2
endif

" Status Line & Numbers
set laststatus=2      " always display status line even if only one window is visible.
set relativenumber    " turn on line numbers
set ruler             " always show current position
set noshowmode
set showcmd           " show incomplete cmds down the bottom

" File Related
set updatetime=1000   " reduce updatetime so current tag in taglist is highlighted faster
set autoread          " suppress warnings when git,etc. changes files on disk.
set autowrite         " write buffers before invoking :make, :grep etc.
set hidden            " allow buffers to go into the background without needing to save
set directory=~/.vim/swap,~/tmp,/var/tmp/,tmp  " Store swapfiles in a single directory.

set wildmode=list:longest,list:full   "make cmdline tab completion similar to bash
set wildmenu                          "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~,.git,.svn,*.rbc,*.class

" Keyboard
set backspace=indent,eol,start "allow backspacing over everything in insert mode

" Other stuff
set history=1000       " Store lots of :cmdline history
set clipboard+=unnamed " On mac, copy to pasteboard

set visualbell         " don't beep constantly, it's annoying.
set t_vb=              " and don't flash the screen either
set guioptions-=T      " hide gvim's toolbar by default

let g:is_posix = 1     " vim's default is archaic bourne shell

set encoding=utf-8
set spelllang=en_us    " Set spell check diectionary to English US.

" Keymapping
" =============================================================

let mapleader = ","

" Cmd j and k for next and previous screen scroll
nmap <C-j> <kPageDown>
nmap <C-k> <kPageUp>

nmap <silent> gk :wincmd k<CR>
nmap <silent> gj :wincmd j<CR>
nmap <silent> gh :wincmd h<CR>
nmap <silent> gl :wincmd l<CR>

" Tag Bindings
map <C-D-.> <C-]>
map <C-D-,> <C-t>

" Opens an edit command with the path of the currently edited file filled in
" Normal mode: <Leader>e
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled in
" Normal mode: <Leader>t
map <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" move forward and backward buffers
map <Leader>, <C-O>
map <Leader>. <C-I>
map <Leader>< :bp<cr>
map <Leader>> :bn<cr>

" quicker to navigate the error window, just control-n, control-p
nmap <C-n> :lnext<CR>
nmap <C-p> :lprevious<CR>
nmap <C-N> :cnext<CR>
nmap <C-P> :cprevious<CR>

"Don't unselect text when indenting/dedenting when in visual mode
vnoremap < <gv
vnoremap > >gv

" Plugins
" =============================================================
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

   filetype off
   set rtp+=~/.vim/bundle/vundle/
   call vundle#rc()
   Bundle 'gmarik/vundle'

   " Status Line:
   Bundle 'https://github.com/bling/vim-airline'
       let g:airline_left_sep=''     " I'm not using custom fonts
       let g:airline_right_sep=''    " That'll just make it less portable
       let g:airline_theme='wombat'
       set ttimeoutlen=50            " Fix the pause when leaving insert mode

       let g:airline#extensions#tabline#enabled = 1

   " File Browsing:
      " Graphical File Browsing
      Bundle 'https://github.com/scrooloose/nerdtree'
         nmap <leader>b :NERDTreeToggle<cr>
         let NERDTreeMinimalUI = 1
         let NERDTreeDirArrows = 1

      " File Search
      Bundle 'kien/ctrlp.vim'
         let g:ctrlp_map = '<leader>o'
         let g:ctrlp_root_markers = ['cscope.out']
         nmap <leader>O :CtrlPBuffer<cr>

   " Programming:
      " Match Delimiters
      runtime macros/matchit.vim  " enable vim's built-in matchit script (make % bounce between tags, begin/end, etc)

      " Syntax Checking
      Bundle 'https://github.com/scrooloose/syntastic/'
          let g:syntastic_always_populate_loc_list = 1
          let g:syntastic_tex_checkers = ['chktex']

      " GPG
      Bundle 'https://github.com/jamessan/vim-gnupg'
          "let g:GPGDefaultRecipients="aaron.kobayashi@gmail.com"

      " Grep
      Bundle 'https://github.com/vim-scripts/EasyGrep'
      let g:EasyGrepWindow=1      " use the location list
      " let g:EasyGrepCommand=1     " use external grep
      let g:EasyGrepMode=2

      " Snippets
      Bundle 'https://github.com/guns/ultisnips'
          let g:UltiSnipsExpandTrigger="<c-j>"
          let g:UltiSnipsJumpForwardTrigger="<c-j>"
          let g:UltiSnipsJumpBackwardTrigger="<c-k>"

      " Code Browsing
      Bundle 'https://github.com/majutsushi/tagbar'
         nmap <leader>n :TagbarToggle<cr>
         " Open on supported file opens
         "autocmd VimEnter * nested :call tagbar#autoopen(1)
         let g:tagbar_sort = 0
         let g:tagbar_width = 20
         let g:tagbar_compact = 1

      " Quickfix / Location list
      Bundle 'https://github.com/milkypostman/vim-togglelist.git'
         " Leader,q and leader l for quickfix and location list

      " Header <-> Source
      Bundle 'https://github.com/vim-scripts/a.vim'
         map <leader>` :A<CR>

      " Commenting
      Bundle 'https://github.com/tomtom/tcomment_vim'
          let g:tcommentMapLeaderOp1 = '<Leader>c'
          let g:tcommentMapLeaderOp2 = '<Leader>C'

	  " Auditing
	  Bundle 'https://github.com/d0c-s4vage/pct-vim'
		  source ~/.vim/bundle/pct-vim/pct.vim

      " Code Completion / Searching
      Bundle 'https://github.com/Valloric/YouCompleteMe.git'
          let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
          let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py']
          let g:ycm_confirm_extra_conf = 0 " turn off confirmation
          let g:ycm_add_preview_to_completeopt = 1 " add preview string
          let g:ycm_autoclose_preview_window_after_completion = 1 " close preview automaticly

      " Beautifying
      Bundle 'https://github.com/godlygeek/tabular.git'
          vmap <leader>a= :Tabularize /=/l1r1<CR>

      " Syntax Files
      Bundle 'https://github.com/jcf/vim-latex'
      let g:Tex_FoldedSections = ''

      " Color Schemes
      Bundle 'https://github.com/tpope/vim-vividchalk'
      Bundle 'https://github.com/vim-scripts/Lucius'

      colorscheme torte

      " Less obnoxious PMenu colors
      hi Pmenu          ctermfg=255 ctermbg=238 guifg=#ffffff guibg=#444444
      hi PmenuSel       ctermfg=0 ctermbg=148 guifg=#000000 guibg=#b1d631
      hi PmenuSbar      ctermbg=7 guibg=Grey
      hi PmenuThumb     ctermbg=15 guibg=Grey

      " Tabline
      hi TabLineFill    ctermfg=238 ctermbg=0
      hi TabLine        ctermfg=255 ctermbg=238
      hi TabLineSel     ctermfg=0 ctermbg=148

      let &colorcolumn=join(range(81,81),",")    " Page guides
      highlight ColorColumn ctermbg=235

   if iCanHazVundle == 0
      echo "Installing Bundles, please ignore key map error messages"
      echo ""
      :BundleInstall
   endif

   filetype plugin indent on
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

  " Text/Tex files
  au BufRead,BufNewFile *.txt,*.tex,*.pgp set wrap linebreak nolist textwidth=80 wrapmargin=0

  " add json syntax highlighting
  au BufNewFile,BufRead *.json set ft=javascript

  " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

endif

" Cscope
if has("cscope")

    function! CscopeExecute(command)
        set nocscopeverbose " suppress 'duplicate connection' error
        exe a:command
        set cscopeverbose " suppress 'duplicate connection' error
    endfunction

    function! CscopeGetDbPath()
        let db = findfile("cscope.out", ".;")
        if (!empty(db))
            let fullPath = fnamemodify(db, ":p")
            let path = strpart(fullPath, 0, match(fullPath, "cscope.out$"))
            return path
        endif
    endfunction

    function! CscopeLoad()
        let path = CscopeGetDbPath()
        if (!empty(path))
            let cmd = "cs add " . path ."/cscope.out " . path
            call CscopeExecute(cmd)
        endif
    endfunction
    au BufEnter /* call CscopeLoad()

    function! CscopeFind(action, word)
        try
            exe ':lcs f '.a:action.' '.a:word
            lw
        catch
            echohl WarningMsg | echo 'Can not find '.a:word.' with querytype as '.a:action.'.' | echohl None
        endtry
    endfunction

    function! CscopeUpdate()
        let path = CscopeGetDbPath()
        if (!empty(path))
            let shellcmd = 'cd "' .path.'" && cscope -b -q'
            let output = system(shellcmd)
            call CscopeExecute(shellcmd)
            call CscopeExecute("cs reset")
        endif
    endfunction
    autocmd BufWritePost,FileWritePost * call CscopeUpdate()

    " s: Find this C symbol
    map <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
    " g: Find this definition
    map <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
    " d: Find functions called by this function
    map <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
    " c: Find functions calling this function
    map <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
    " t: Find this text string
    map <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
    " e: Find this egrep pattern
    map <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
    " f: Find this file
    map <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
    " i: Find files #including this file
    map <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>
    " u: Update cscope
    map <leader>fu :call CscopeUpdate()<CR>

    " show msg when any other cscope db added
    set nocscopeverbose

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " use cscope db first
    set csto=0

    " Only display last 3 path components
    "set cspc=3

    " quickfix setup
    set cscopequickfix=s-,g-,c-,t-,d-,i-,t-,e-

endif


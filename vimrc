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
" set expandtab         " Use spaces
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
set number			  " always turn on line numbers
set relativenumber    " make them relative
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

" Tabs
map <C-H> :tabprevious<CR>
map <C-L> :tabnext<CR>
map <C-C> :tabclose<CR>

" Windows
map <C-W>H :wincmd h<CR>
map <C-W>J :wincmd j<CR>
map <C-W>K :wincmd k<CR>
map <C-W>L :wincmd l<CR>

" Jump list
map <Leader>, <C-O>
map <Leader>. <C-I>

" Buffers
map <Leader>< :bp<CR>
map <Leader>> :bn<CR>

" Location/Quickfix Lists
map <C-J> :lnext <CR>
map <C-K> :lprevious<CR>

" Use grep -Rn <search term> * | vim -
map <C-o> <C-w>gF:setlocal ro<CR>:setlocal nomodifiable<CR>

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
   Bundle 'https://github.com/gmarik/vundle.git'

   " Status Line:
   Bundle 'https://github.com/bling/vim-airline'
       let g:airline_left_sep=''     " I'm not using custom fonts
       let g:airline_right_sep=''    " That'll just make it less portable
       let g:airline_theme='wombat'
       set ttimeoutlen=50            " Fix the pause when leaving insert mode

       let g:airline#extensions#tabline#show_buffers = 0  " Buffers aren't tabs

   " File Browsing:
      " Graphical File Browsing
      Bundle 'https://github.com/scrooloose/nerdtree'
         nmap <leader>b :NERDTreeToggle<cr>
         let NERDTreeMinimalUI = 1
         let NERDTreeDirArrows = 1

      " File Search
      Bundle 'https://github.com/kien/ctrlp.vim'
         let g:ctrlp_map = '<leader>o'
         let g:ctrlp_root_markers = ['cscope.out']
		 let g:ctrlp_follow_symlinks = 1
		 let g:ctrlp_working_path_mode = 'ra'

   " Programming:
      " Match Delimiters
      runtime macros/matchit.vim  " enable vim's built-in matchit script (make % bounce between tags, begin/end, etc)

      " Code Browsing
      Bundle 'https://github.com/majutsushi/tagbar'
         nmap <leader>t :TagbarToggle<cr>
         " Open on supported file opens
         let g:tagbar_sort = 0
         let g:tagbar_width = 30
         let g:tagbar_compact = 1

      " Header <-> Source
      " Bundle 'https://github.com/vim-scripts/a.vim'
      "    map <leader>` :A<CR>

      " Commenting
      Bundle 'https://github.com/tomtom/tcomment_vim'
          let g:tcommentMapLeaderOp1 = '<Leader>c'
          let g:tcommentMapLeaderOp2 = '<Leader>C'

	  Bundle 'https://github.com/vim-scripts/Mark--Karkat'
         map <leader>M :MarkClear<CR>

	  " Stuff i only really use on osx
	  if has("unix")
		  let s:uname = system("uname")
		  if s:uname == "Darwin\n"
			  Bundle 'https://github.com/d0c-s4vage/pct-vim'

			  " Code Completion / Searching
			  Bundle 'https://github.com/Valloric/YouCompleteMe.git'
			  let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
			  let g:ycm_extra_conf_globlist = ['~/.ycm_extra_conf.py']
			  let g:ycm_confirm_extra_conf = 0 " turn off confirmation
			  let g:ycm_add_preview_to_completeopt = 1 " add preview string
			  let g:ycm_autoclose_preview_window_after_completion = 1 " close preview automaticly
		  endif

		  " nvim
		  Bundle "https://github.com/cwoac/nvim.git"
		  Bundle "https://github.com/tpope/vim-markdown.git"

		  " GPG
		  Bundle 'https://github.com/jamessan/vim-gnupg'
			  let g:GPGDefaultRecipients="aaron.kobayashi@gmail.com"
	  endif

      " Beautifying
	  Bundle 'https://github.com/junegunn/vim-easy-align.git'
		  " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
		  vmap <Enter> <Plug>(EasyAlign)
		  nmap ga <Plug>(EasyAlign)

   " Other:

      " Quickfix / Location list
      Bundle 'https://github.com/milkypostman/vim-togglelist.git'
         " Leader,q and leader l for quickfix and location list

	  " Easy Motion
	  Bundle 'https://github.com/Lokaltog/vim-easymotion'
		  let g:EasyMotion_do_mapping = 0 " Disable default mappings
		  let g:EasyMotion_smartcase = 1
		  nmap s <Plug>(easymotion-s2)
		  map <Leader>j <Plug>(easymotion-j)
		  map <Leader>k <Plug>(easymotion-k)

      " Ultisnips + Snippets
      Bundle 'https://github.com/SirVer/ultisnips'
	  Bundle 'https://github.com/honza/vim-snippets'

		  " This hack from https://github.com/SirVer/ultisnips/issues/376#issuecomment-69033351
		  " Enables tab to move up and down the ycm list, and return to accept
		  " a snippet.  It also allows tab to move between ultisnips fields
		  let g:ycm_key_list_select_completion=["<tab>"]
		  let g:ycm_key_list_previous_completion=["<S-tab>"]

		  let g:UltiSnipsJumpForwardTrigger="<tab>"
		  let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
		  let g:UltiSnipsExpandTrigger="<nop>"
		  let g:ulti_expand_or_jump_res = 0
		  function! <SID>ExpandSnippetOrReturn()
			  let snippet = UltiSnips#ExpandSnippetOrJump()
			  if g:ulti_expand_or_jump_res > 0
				  return snippet
			  else
				  return "\<CR>"
			  endif
		  endfunction
		  inoremap <expr> <CR> pumvisible() ? "<C-R>=<SID>ExpandSnippetOrReturn()<CR>" : "\<CR>"

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

  " Use relative number when focused
  au WinLeave * :set norelativenumber number
  au WinEnter * :set relativenumber number

  " Automatically strip trailing white spaces.
  au BufWritePre * :%s/\s\+$//e

  " Remember last location in file
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif

  " Syntax of these languages are fussy over tabs Vs spaces
  au FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
  au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

  " Text files
  au BufRead,BufNewFile *.txt,*.tex,*.pgp set wrap linebreak nolist textwidth=80 wrapmargin=0
  au BufRead,BufNewFile *.txt,*.tex,*.pgp setlocal spell complete+=kspell

  " Mail
  au FileType mail set spell complete+=kspell

  " MD Files
  au BufRead,BufNewFile *.md set ft=markdown
  " Turn off the messed up _ processing
  au BufRead,BufNewFile *.md syn match markdownError "\w\@<=\w\@="

  " add json syntax highlighting
  au BufNewFile,BufRead *.json set ft=javascript

  " Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
  au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

endif

" ag  - The Silver Searcher
"
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ -f\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -f -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0


  " The following doesnt work :(
	" function! LGrep(search)
	"	execute "unsilent silent lgrep --binary-files=without-match --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg -R " a:search " *"
	" endfunction

	function! LGrep2(search)
		tabnew
		execute "silent grep " a:search " >/tmp/lgrep.txt"
		lf /tmp/lgrep.txt
		silent !rm /tmp/lgrep.txt
		lop | wincmd k
	endfunction

	command! -nargs=1 Llgrep execute 'call LGrep2("<args>")'
	map ,s :Llgrep<space>
	map ,S :execute 'Llgrep '.expand('<cword>')<CR>

	function! CSC2(search)
		tabnew
		execute "tag " a:search
		" lop | wincmd k
	endfunction
	command! -nargs=1 CSC execute 'call CSC2("<args>")'
    map ,C :execute 'CSC '.expand("<cword>")<CR>

	" function! LGrep(search)
	"	tabnew
	"	"execute "silent lgrep "a:search
	"	execute "silent lgrep --binary-files=without-match --exclude-dir=.git --exclude-dir=.svn --exclude-dir=.hg -R " a:search " *"
	"	lop
	" endfunction
    "
	" command! -nargs=1 Llgrep execute 'call LGrep("<args>")'
	" map ,s :Llgrep
	" map ,S :execute 'Llgrep '.expand('<cword>')<CR>
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
			exe ':tabnew | :tab lcs f '.a:action ' ' .a:word
			exe ':lop | :wincmd k'
        catch
			exe ':tabclose'
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
    set cscopeverbose

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " use cscope db first
    set csto=1

    " Only display last 3 path components
    set cspc=3

    " quickfix setup
    set cscopequickfix=s-,g-,c-,t-,d-,i-,t-,e-

endif


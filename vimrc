" Aaron Kobayashi's vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Vim settings, rather then Vi settings (much better!).
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup		  " Keep no backups
set history=50		" keep 50 lines of command line history
set ruler		      " show the cursor position all the time
set showcmd		    " display incomplete commands
set incsearch		  " do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
  augroup END

else

  set autoindent		" always set autoindenting on

endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

set number

if has("gui_running")
  set transp=0
  set lines=75
  set columns=300
  "set autochdir
endif

" Configure Color Scheme
set background=dark
colorscheme vividchalk

" Configure Tlist
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"
let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=1
let Tlist_Show_One_File=1 " especially with this one let 
let Tlist_Compact_Format=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Close_On_Select=0
let Tlist_GainFocus_On_ToggleOpen=0
let Tlist_Use_SingleClick=1
let Tlist_Show_Menu=1
let Tlist_Auto_Open=0
let Tlist_Display_Prototype = 0
let Tlist_Exit_OnlyWindow = 1

" let tlist_php_settings = 'php;c:class;d:constant;f:function;v:variable'

"If 1 second goes by and nothing is typed the swap file will be written to disk 
set updatetime=1000

" Tabs
set ts=2 sw=2 et

" Visual Block Indents
:vnoremap > >gv
:vnoremap < <gv

" Turn off folds
set nofen

" Fonts
set guifont=Monaco:h12
set guioptions=egmrLt
set enc=utf-8
hi LineNr guifg=#cccccc
hi LineNr guibg=#272727

" Cursorline
set cursorline
au WinEnter * setlocal cursorline
au WinLeave * setlocal nocursorline

" Case only matters with mixed case expressions
set ignorecase
set smartcase

" Reload vimrc
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" File Sytem Navigation (Nerd tree, Fuzzy Finder)
map <leader>e :execute 'NERDTreeToggle ' . escape(getcwd(),'\ ')<CR>
let NERDTreeShowBookmarks=1 

nnoremap <leader>f :FuzzyFinderFile <C-r>=fnamemodify(escape(getcwd(), '\ '), ':p')<CR><CR> 
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>t :Tlist<CR>
map <leader>w :set lines=101<CR>:set columns=362<CR>
map <leader>W :set lines=75<CR>:set columns=300<CR>

" Indicate the line is too long
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.*/

" Use Ack instead of Grep when available
if executable("ack")
  set grepprg=ack\ -H\ --nogroup\ --nocolor
endif

" Rails.vim shortcuts
map <Leader>m :Rmodel 
map <Leader>c :Rcontroller 
map <Leader>v :Rview 
map <Leader>u :Runittest 
map <Leader>f :Rfunctionaltest 
map <Leader>vm :RVmodel 
map <Leader>vc :RVcontroller 
map <Leader>vv :RVview 
map <Leader>vu :RVunittest 
map <Leader>vf :RVfunctionaltest 
map <Leader>vm :RSmodel 
map <Leader>sc :RScontroller 
map <Leader>sv :RSview 
map <Leader>su :RSunittest 
map <Leader>sf :RSfunctionaltest 

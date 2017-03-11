
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Add man pages (:Man <foo>)
runtime ftplugin/man.vim

" Change tab on spaces
set expandtab

" Highlights the matching pairs of parentheses
set showmatch

" Unset wraping
set nowrap

" Ignore cases and if the searched phrase contains uppercase, vim turn off
" inorecase
set ignorecase
set smartcase

" 8 characters tabs
set tabstop=2

" 4 characters shift width 
set shiftwidth=2

" Set shift width to variable shiftwidth
set shiftround

" Number of lines
" set number

" pathogen
call pathogen#incubate()
call pathogen#helptags()

" NerdTree
:noremap <F4> :NERDTreeToggle <Enter>

" TagList
:noremap <F5> :TlistToggle <Enter>
let Tlist_Use_Right_Window = 1
let Tlist_Inc_Winwidth = 0
let Tlist_WinWidth = 45
let Tlist_GainFocus_On_ToggleOpen= 1
let Tlist_Ctags_Cmd = 'ctags'
let Tlist_Show_One_File = 1

" QFEnter
let g:qfenter_open_map = ['<CR>', '<2-LeftMouse>']
let g:qfenter_vopen_map = ['<Leader><CR>']
let g:qfenter_hopen_map = ['<Leader><Space>']
let g:qfenter_topen_map = ['<Leader><Tab>']

" youcompleteme
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_min_num_of_chars_for_completion = 2

" QuickFix
:noremap <F7> :cope <Enter>

" compilation setup
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = '-std=c++11 -pthread -lpthread -stdlib=libc++'

let g:C_CCompiler = 'g++ -pthread -lpthread' "/clang++/ ~/filter/gfilt
let g:C_LFlags = ' -std=c++14 -Wall -g' " -lboost_regex -O0 ten
let g:C_Libs = '-lgtest -lpthread'
let g:C_CFlags = '-std=c++14 -Wall -g -c -lgtest -lpthread' "pthread lboost_regex -O0

let g:C_UseTool_cmake = 'yes'

" copy current window to new tab
:noremap <F8> :tab sp <Enter>

let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout ttimeoutlen=50

" open ctag in vertical split
:noremap <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR> :wincmd x <Enter> :wincmd w <Enter>

" open ctag in new tab
:noremap <C-@> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" go to the next/previous tag
:noremap <C-Right> :tnext <Enter>
:noremap <C-Left> :tprevious <Enter>


" ******* TMP *******

" go to the .cpp file
:noremap <F3> <CR>:e %:h/../Source/%:t:r.cpp <Enter>
:noremap <F2> <CR>:e %:h/../Include/%:t:r.hpp <Enter>

" make configuration
:noremap <F6> :make -f makefile 

" ttcn3
syntax on
au BufRead,BufNewFile *.ttcn* set filetype=ttcn
au! Syntax ttcn source ~/.vim/syntax/ttcn.vim

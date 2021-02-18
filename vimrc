" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set ruler		        " Show the cursor position all the time.
set showcmd		        " Display incomplete commands.
set wildmenu		        " Display completion matches in a status line.
set timeout                     " Time out for mappings.
set ttimeout                    " Time out for <Esc> key codes.
set timeoutlen=500              " Wait 500 milliseconds before timing out a mapping.
set ttimeoutlen=100             " Wait 100 milliseconds before timing out an <Esc> key code.
set display=truncate            " Show @@@ in the last line if it is truncated.
set number                      " Enable line numbers
set relativenumber              " Use relative line numbers
set linebreak                   " Wrap at word boundaries
set backupcopy=yes              " Support tools that detect file changes

" Show a few lines of context around the cursor. Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=4

" Tabs and indentation
set softtabstop=4               " <Tab> inserts 4 columns.
set shiftwidth=4                " Indent using 4 columns.
set expandtab                   " <Tab> inserts spaces instead of tabs.
set smarttab                    " When <Tab> is pressed at the beginning of a line,
                                "     use 'shiftwidth' columns instead of 'softtabstop'.
filetype plugin indent on       " Enable filetype detection, plugins, and indenting.
syntax enable                   " Enable filetype-based syntax highlighting.

autocmd FileType html setlocal softtabstop=2 shiftwidth=2
autocmd FileType htmldjango setlocal softtabstop=2 shiftwidth=2

" Change cursor shape in different modes
let &t_SI .= "\e[6 q"           " INSERT mode
let &t_SR .= "\e[4 q"           " REPLACE mode
let &t_EI .= "\e[2 q"           " NORMAL mode

" Key mappings
inoremap kj <Esc>
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <silent> <Leader>f :NERDTreeToggle<CR>

" Plugins
if has('win32')
    let $VIMDIR = $USERPROFILE . '/vimfiles'
else
    let $VIMDIR = $HOME . '/.vim'
endif

" Install vim-plug
if empty(glob($VIMDIR . '/autoload/plug.vim'))
  silent !curl -sLo $VIMDIR/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin($VIMDIR . '/plugged')
    " Language pack
    Plug 'sheerun/vim-polyglot'

    " Writing experience
    Plug 'junegunn/goyo.vim'                " Centered, distraction-free writing
    Plug 'junegunn/limelight.vim'           " Spotlight the current paragraph

    " Additional features
    Plug 'scrooloose/nerdtree'                              " File tree/browser
call plug#end()

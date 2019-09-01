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

" Key mappings
inoremap kj <Esc>
inoremap lkj <Esc>:w<CR>
inoremap ;lkj <Esc>:wq<CR>

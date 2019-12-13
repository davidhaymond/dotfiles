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
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l
nnoremap <silent> <Leader>f :NERDTreeToggle<CR>

" Plugins
if has('win32')
    let $PLUGGEDDIR = '~/vimfiles/plugged'
else
    let $PLUGGEDDIR = '~/.vim/plugged'
endif
call plug#begin($PLUGGEDDIR)
    " Filetype plugins
    Plug 'PProvost/vim-ps1'                 " PowerShell
    Plug 'pangloss/vim-javascript'          " JavaScript
    Plug 'plasticboy/vim-markdown'          " Markdown
    Plug 'cespare/vim-toml'                 " TOML
    Plug 'mustache/vim-mustache-handlebars' " Mustache/Handlebars

    " Writing experience
    Plug 'junegunn/goyo.vim'                " Centered, distraction-free writing
    Plug 'junegunn/limelight.vim'           " Spotlight the current paragraph

    " Additional features
    Plug 'scrooloose/nerdtree'                              " File tree/browser
    Plug 'christoomey/vim-tmux-navigator'                   " Tmux shortcut integration
    Plug 'suan/vim-instant-markdown', {'for': 'markdown'}   " Markdown previews

    " Colorschemes
    Plug 'tomasr/molokai'                   " Molokai
call plug#end()

" Plugin-related options
" ----------------------
silent! colorscheme molokai                 " Molokai colorscheme

" vim-markdown options
let g:vim_markdown_folding_disabled = 1

" vim-instant-markdown options
let g:instant_markdown_slow = 1     " Slower preview updates
let g:instant_markdown_port = 8080  " localhost:8080 is automatically forwarded to Crostini on Chrome OS, removing the need for g:instant_markdown_open_to_the_world

" {{{ Global Variables

let g:is_posix = 1                                  " Assume shell for syntax highlighting.

" Settings for custom statusline.
if !exists('g:vscode')
    let g:lightline = {
        \ 'colorscheme': 'nord',
    \ }
endif

" Global Variables }}}

" {{{ Plugins Related

call plug#begin('~/.local/share/nvim/plugin/')

if !exists('g:vscode')
    Plug 'arcticicestudio/nord-vim'
    Plug 'itchyny/lightline.vim'
endif

call plug#end()

" Plugins Related }}}

" {{{ Vim options

colorscheme nord                                    " Set color scheme

set nocompatible                                    " Remove vi compatibility hacks.
let mapleader = "\<Space>"                          " Set <Leader> to Spacebar.

syntax enable                                       " Turn on syntax highlighting.
filetype plugin indent on                           " Use file-specific plugins and indentation rules.

set autoindent                                      " Moving to a new line keeps the same indentation (overridden by filetype indent on).
set autoread                                        " Auto read when file is changed elsewhere.
set backspace=indent,eol,start                      " Backspace works across lines.
set cmdheight=2                                     " Give more space for displaying messages.
set confirm                                         " Ask if you want to save unsaved files instead of failing.
set diffopt+=vertical                               " Always use vertical diffs.
set expandtab                                       " Insert spaces when tab key pressed.
set ffs=unix                                        " Force Unix line endings (\n) (always show \r (^M), never autoinsert them).
set foldmethod=expr foldlevel=99                    " Fold according to the syntax rules, expand all by default.
set formatoptions-=t                                " Don't autowrap text at 80.
set gdefault                                        " Global replace default (off: /g).
set hidden                                          " Don't force saving buffers on switching.
set history=1000                                    " More command/search history.
set hlsearch                                        " Highlight search matches (off: <Space>/).
set ignorecase                                      " Ignore case for lowercase searches (re-enable with \C in pattern),
set incsearch                                       " Incremental searching.
set laststatus=2                                    " Always display the status line.
set lazyredraw                                      " Don't redraw if you don't have to (e.g. in macros).
set list listchars=tab:»·,trail:·,nbsp:☠            " Display extra whitespace.
set mouse=a                                         " Mouse in all modes (mac: Fn+drag = copy).
set nojoinspaces                                    " One space (not two) after punctuation..
set nonumber                                        " Turn off line numbers.
set noshowmode                                      " Don't show when in insert mode (set in lightline).
set notildeop                                       " Keep tilde (~) as it's default. If you want the operator version use g~.
set ruler                                           " Always show cursor position.
set shiftwidth=4 tabstop=4 softtabstop=4            " Set tab width to 2.
set shortmess+=c                                    " Don't pass messages to |ins-completion-menu|.
set showcmd                                         " Display incomplete commands.
set signcolumn=auto                                 " Resize the sign column automatically.
set smartcase                                       "  ↳ don't for mixed-case.
set splitbelow                                      " Open new split panes to right and,
set splitright                                      "  ↳ bottom, which feels more natural.
set t_Co=256                                        " Use 256 color terminal.
set termguicolors                                   " Uses 24-bit colors in the terminal (guifg and guibg).
set undolevels=1000                                 " More undo history.
set updatetime=100                                  " Delay after which to write to swap file and run CursorHold event.
set visualbell                                      " Flash the screen instead of beeping when doing something wrong.
set wildchar=<Tab> wildmenu                         " Tab complete with files (e.g. `:e`)
set wildmode=list:longest,list:full                 " 1st Tab completes to longest common string, 2nd+ cycles through options.

let s:undodir = $XDG_CACHE_HOME . "/nvim/undo"
if !isdirectory(s:undodir)| call mkdir(s:undodir, "p", 0700)| endif
set path=.,/usr/include,,**                         " Add ** to the search path so :find x works recursively.
if exists('+breakindent')| set breakindent| let &showbreak = '↳   '| set cpo+=n| end " Nicer line wrapping for long lines.
if exists('&inccommand')| set inccommand=split| endif " Show search and replace as you type.
if exists("&wildignorecase")| set wildignorecase| endif " Case insensitive file tab completion with :e.

" Vim options }}}

" {{{ Key mappings

if exists('g:vscode')
    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine
endi

" Key mappings }}}

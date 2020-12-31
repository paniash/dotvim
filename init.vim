" Vim configuration
"
" Author: Ashish Panigrahi <ashish.panigrahi@protonmail.com>

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'SirVer/ultisnips', { 'for': 'tex' }
Plug 'tpope/vim-commentary'
Plug 'morhetz/gruvbox'
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': ['markdown', 'rmd'] }
Plug 'jpalardy/vim-slime', { 'for': 'python' }
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/goyo.vim'
call plug#end()

" Some basic stuff
set termguicolors
set nohlsearch
set clipboard+=unnamedplus
set mouse=a

set noswapfile
set noerrorbells
set number relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" Highlights regex expressions when using substitute (only works on neovim)
set inccommand=nosplit

" Assigns leader and localleader keys
let mapleader=","
let maplocalleader=","

"" Vimtex settings
let g:tex_flavor = "latex"
let g:vimtex_view_method = "zathura"
let g:vimtex_view_automatic = 0
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_syntax_enabled = 0

" Don't let vimtex autoindent things (it sucks at it).
let g:vimtex_indent_enabled = 0
let g:latex_indent_enabled = 0

" Disable insert mode mappings
let g:vimtex_imaps_enabled = 0

" Make vimtex recognise end-of-line comments when using 'gq'.
let g:vimtex_format_enabled = 1

let g:vimtex_compiler_latexmk = {
    \ 'continuous' : 0,
    \}

augroup vimrc_tex
    au!
    au FileType tex nmap <buffer><silent> <localleader>c <plug>(vimtex-compile)
    au FileType tex nmap <buffer><silent> <localleader>v <plug>(vimtex-view)
    au FileType tex nmap <buffer><silent> <localleader>b <plug>(vimtex-errors)
    au FileType tex nmap <buffer><silent> <localleader>g :VimtexCountWord<CR>
    au FileType tex nmap <buffer><silent> <space>l :!chktex %<CR>
augroup END

" UltiSnips settings
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-Tab>'
let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsSnippetDirectories=['~/.config/nvim/UltiSnips']
map <leader>u :UltiSnipsEdit<CR>


" Colorscheme settings with personal modifications
let g:gruvbox_bold = 1
let g:gruvbox_contrast_dark = 'hard'

set background=dark

function! AdjustGruvbox()
    highlight! EndOfBuffer gui=bold guibg=bg guifg=#7c6f64
    highlight! CursorLineNr guibg=bg
    highlight! SpecialKey guifg=#A9B4B2
    highlight! StatusLine guibg=#282828 guifg=#A9B4B2 gui=bold
    highlight! StatusLineNC guifg=#282828
    highlight! TabLineFill guibg=bg
    highlight! TabLineSel guibg=bg gui=bold
endfunction

augroup gruvbox_colors
    autocmd!
    autocmd ColorScheme gruvbox call AdjustGruvbox()
augroup END

colorscheme gruvbox


" Goyo settings
nnoremap <leader>g :Goyo<CR>

let g:goyo_width = 140

" Ensure :q to quit even when Goyo is active
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter call <SID>goyo_enter()
autocmd! User GoyoLeave call <SID>goyo_leave()


" Python settings
let g:python_highlight_builtins = 1
let g:python_highlight_exceptions = 1
let g:python_highlight_doctests = 1
let g:python_highlight_operators = 1
let g:python_highlight_class_vars = 1
let g:python_highlight_func_calls = 1

let g:python3_host_prog = '/usr/bin/python3'  " Sets path for python executable for faster startup
let g:loaded_python_provider = 0  " Disables python 2 support

augroup python_execute
    au!
    au FileType python nmap <leader>c :w! \| :!python %<CR>
    au FileType python nmap <leader>s :SlimeSend1 ipython<CR>
    au FileType python nmap <leader>a <Plug>SlimeLineSend
    au FileType python xmap <leader>a <Plug>SlimeRegionSend
    au FileType python nmap <leader>d <Plug>SlimeSendCell
    au FileType python nmap <leader>x :norm I#%%<Esc>
    au BufNewFile,BufRead *.py
                \ set tabstop=4 |
                \ set softtabstop=4 |
                \ set shiftwidth=4 |
                \ set textwidth=79 |
                \ set expandtab |
                \ set smartindent |
                \ setlocal wildignore=*.pyc
augroup END

" Slime settings
let g:slime_target = "tmux"
let g:slime_python_ipython = 1
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_dont_ask_default = 1
let g:slime_cell_delimiter = "#%%"
let g:slime_no_mappings = 1


" C settings
augroup c_execute
    au!
    au FileType c nmap <leader>c :w! \| :!gcc % && ./a.out<CR>
    au FileType c nmap <leader>g :w! \| :!gcc -O -Wall -W -pedantic %<CR>
    au FileType c nmap <leader>l :w! \| :!splint %<CR>
augroup END


" Markdown compilation
augroup markdown
    au!
    au FileType markdown,rmd nmap <leader>c :w! \| :!markcompiler <c-r>%<CR><CR>
    au FileType markdown,rmd nmap <leader>v :!opout <c-r>%<CR><CR>
augroup END


" Netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_preview = 1

augroup netrw_mapping
    au!
    au FileType * nmap <buffer><silent> <leader>nn :Lex<CR>
augroup END

" Enables vim-pandoc syntax in markdown files
augroup pandoc_syntax
    au! FileType markdown set syntax=markdown.pandoc
augroup END

" Ignore case when searching but be case-sensitive when one or more UPPER case characters exist
set ignorecase
set smartcase

" Breaks visual lines
set linebreak

" Split windows in a more natural way
set splitbelow
set splitright

" Sane keybindings for moving around windows
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Bindings for moving around tabs
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>

" Fast saving
nnoremap <leader>w :w<CR>

" Easier indentation of code blocks
vnoremap < <gv
vnoremap > >gv

" Saving file with sudo privileges in regular vim
cmap w!! w !sudo tee > /dev/null %

" Fix Y behaviour
nmap Y y$

" Replace ex mode with gq
map Q gq

" Toggle spellchecker
function! ToggleSpellCheck()
    set spell!
    if &spell
        echo "Spellcheck ON"
    else
        echo "Spellcheck OFF"
    endif
endfunction

nnoremap <silent> <leader>z :call ToggleSpellCheck()<CR>

" Replace all aliased to S
nnoremap S :%s//g<Left><Left>

" Never show statusline (0) or always show statusline (2)
set laststatus=1

" Disables pipe cursor when in insert mode (vim like)
set guicursor=

"" Autocommands
" Runs script to clean tex build files
autocmd VimLeave *.tex !texclear %

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Automatically deletes all trailing whitespace and newlines at end of file on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" Function to enable or disable statusline
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all == 1
        let s:hidden_all = 0
        set laststatus=2
    else
        let s:hidden_all = 1
        set laststatus=1
    endif
endfunction

nnoremap <S-h> :call ToggleHiddenAll()<CR>

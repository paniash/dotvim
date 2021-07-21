" Vim configuration
"
" Author: Ashish Panigrahi <ashish.panigrahi@protonmail.com>

if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

lua <<EOF
vim.g.kommentary_create_default_mappings = false
EOF

" Plugins
call plug#begin('~/.config/nvim/plugged')
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'SirVer/ultisnips', { 'for': ['tex', 'markdown', 'html', 'snippets'] }
Plug 'b3nj5m1n/kommentary'
Plug 'gruvbox-community/gruvbox'
Plug 'jpalardy/vim-slime', { 'for': ['python', 'julia'] }
Plug 'christoomey/vim-tmux-navigator'
Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' }
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'markdown' }
call plug#end()


" To duplicate tpope's defaults
lua <<EOF
vim.api.nvim_set_keymap("n", "gcc", "<Plug>kommentary_line_default", {})
vim.api.nvim_set_keymap("n", "gc", "<Plug>kommentary_motion_default", {})
vim.api.nvim_set_keymap("v", "gc", "<Plug>kommentary_visual_default<C-c>", {})
EOF

let g:tex_fast = ""
set shell=/bin/sh

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
let g:vimtex_context_pdf_viewer = "zathura"
let g:vimtex_view_automatic = 0
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_autojump = 0
let g:vimtex_syntax_enabled = 1

" Don't let vimtex autoindent things (it sucks at it).
let g:vimtex_indent_enabled = 1
let g:latex_indent_enabled = 1

" Disable insert mode mappings and normal mode mappings
let g:vimtex_imaps_enabled = 0
let g:vimtex_mappings_enabled = 1

" Make vimtex recognise end-of-line comments when using 'gq'.
let g:vimtex_format_enabled = 1

" Disable folding in bib files
let g:vimtex_fold_bib_enabled = 0

let g:vimtex_compiler_latexmk = {
    \ 'continuous' : 0,
    \}

augroup vimrc_tex
    au!
    au FileType tex nmap <buffer><silent> <localleader>c <plug>(vimtex-compile)
    au FileType tex nmap <buffer><silent> <localleader>v <plug>(vimtex-view)
    au FileType tex nmap <buffer><silent> <localleader>b <plug>(vimtex-errors)
    au FileType tex nmap <buffer><silent> <space>g :VimtexCountWord<CR>
    au FileType tex nmap <buffer><silent> <space>l :!chktex %<CR>
    au FileType tex nmap <buffer><silent> <space>c <plug>(vimtex-clean)
    au FileType tex :NoMatchParen
    au FileType tex setlocal nocursorline
    au FileType tex set foldmethod=diff
augroup END


" UltiSnips settings
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-Tab>'
let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips']
map <leader>u :UltiSnipsEdit<CR>


" Colorscheme settings with personal modifications
let g:gruvbox_bold = 1
let g:gruvbox_contrast_dark = 'hard'

set background=dark

function! AdjustGruvbox()
    highlight! Normal guibg=#1c1c1c
    highlight! EndOfBuffer gui=bold guibg=bg guifg=#7c6f64
    highlight! CursorLineNr guibg=bg
    highlight! SpecialKey guifg=#A9B4B2
    " highlight! StatusLine guifg=#282828 guibg=#A9B4B2
    highlight! StatusLine guifg=#1c1c1c guibg=#999999 gui=bold
    highlight! StatusLineNC guifg=#282828
    highlight! TabLineFill guibg=bg
    highlight! TabLineSel guibg=bg guifg=#A9B4B2 gui=bold
endfunction

augroup gruvbox_colors
    autocmd!
    autocmd ColorScheme gruvbox call AdjustGruvbox()
augroup END

colorscheme gruvbox


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

augroup julia_execute
    au!
    au FileType julia nmap <leader>s :SlimeSend1 julia<CR>
    au FileType julia nmap <leader>a <Plug>SlimeLineSend
    au FileType julia xmap <leader>a <Plug>SlimeRegionSend
    au FileType julia nmap <leader>d <Plug>SlimeSendCell<CR>
    au FileType julia nmap <leader>x :norm I#%%<Esc>
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
    au FileType c nmap <leader>c :!gcc -lm % && ./a.out<CR>
    au FileType c nmap <leader>g :!gcc -lm -O -Wall -Werror -Wextra -pedantic %<CR>
    au FileType cpp nmap <leader>g :!g++ -std=c++11 -O2 -Wall % -o bin<CR>
    au FileType cpp nmap <leader>c :!g++ -std=c++11 -O2 -Wall % -o bin && ./bin<CR>
    au FileType c nmap <leader>l :w! \| :!splint %<CR>
	au FileType c,cpp set noexpandtab
augroup END

let g:c_syntax_for_h = 1

" Ensure that tabs don't get converted to spaces in Makefiles
autocmd FileType make setlocal noexpandtab

" Markdown compilation
augroup doc_compile
    au!
    au FileType markdown,rmd nmap <leader>c :!markcompiler %<CR><CR>
    au FileType markdown,rmd,html nmap <leader>v :!opout %<CR><CR>
    au FileType markdown set conceallevel=0
    autocmd BufNewFile,BufRead,BufWrite *slide*.md,*pres*.md nmap <leader>c :w! \| :!slider %<CR><CR>
augroup END

" Netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_preview = 1

augroup netrw_mapping
    au!
    au FileType * nmap <buffer><silent> <Space>x :Lex<CR>
augroup END

" Enables pandoc syntax for markdown files
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

" Disable mapping
nnoremap Q <nop>

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

" Binding to display filetype in current buffer
nnoremap <C-b> :echo &ft<CR>

" Allows text object operations with '$<string>$'
:onoremap <silent> i$ :<C-U>normal! T$vt$<CR>
:onoremap <silent> a$ :<C-U>normal! F$vt$<CR>

" Never show statusline (0) or always show statusline (2)
set laststatus=1

"" Autocommands
" Runs script to clean tex build files
autocmd VimLeave *.tex !texclear %

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Disable a lot of unnecessary internal plugins
let g:loaded_2html_plugin = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_gzip = 1
let g:loaded_logipat = 1
let g:loaded_rrhelper = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zipPlugin = 1

" Removes newlines at the end of the file and trailing whitespaces only for non-test files
autocmd BufWritePre * let current_pos = getpos(".")
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre [^\(test\)]* %s/\s\+$//e
autocmd BufWritePre * call setpos(".", current_pos)

" Spelling mistakes will be colored red when using spellchecker
hi SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f
hi SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f

" Function to enable or disable statusline
let s:hidden_all = 1
function! ToggleHiddenAll()
    if s:hidden_all == 0
        let s:hidden_all = 1
        set laststatus=1
    else
        let s:hidden_all = 0
        set laststatus=2
    endif
endfunction

nnoremap <Space>z :call ToggleHiddenAll()<CR>

" Display a message when the current file is not in utf-8 format.
" Note that we need to use `unsilent` command here because of this issue:
" https://github.com/vim/vim/issues/4379.
augroup non_utf8_file_warn
    autocmd!
    autocmd BufRead * if &fileencoding != 'utf-8' && expand('%:e') != 'gz'
                \ | unsilent echomsg 'File not in UTF-8 format!' | endif
augroup END


" Treesitter goodies
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ignore_install = { "dockerfile" }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "dockerfile", "scss", "html" },  -- list of language that will be disabled
  },
}
EOF

" Builtin on yank highlight
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150, on_visual=false}

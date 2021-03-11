"" vim-airline/vim-airline
"" Airline settings
let g:airline_theme='dark'

let g:airline_symbols_ascii = 1
let g:airline_detect_spell=0
let g:airline_detect_spelllang=0
let g:airline_disable_statusline=0
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#wordcount#filetypes = 	['vimwiki', 'tex', 'rmd', 'markdown', 'text']
" let g:airline#extensions#wordcount#formatter = 'default'
let g:airline#extensions#wordcount#formatter#default#fmt = '%s words'

let g:airline#extensions#default#layout = [
 			\ ['a', 'b', 'c'],
 			\ ['x', 'y', 'z']
 			\ ]

set noshowmode

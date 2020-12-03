" Lightline settings
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'wordcount' ] ],
      \   'left': [ [ 'mode'],
      \             [ 'filename', 'modified' ] ],
      \ },
      \ 'component_function': {
      \   'wordcount': 'LightlineWordCount'
      \ },
      \ }

function! LightlineWordCount() abort
    return &filetype =~# '\v(tex|markdown)' ? wordcount().words . ' words' : ''
endfunction

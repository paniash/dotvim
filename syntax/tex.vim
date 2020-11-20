" Minimal (La)TeX syntax highlighting
" because the default tex.vim is waaaay too slow for me.
"
" Language:     TeX
" Author:       Jake Lishman <jakelishman@gmail.com>
" Modified:     Ashish Panigrahi <ashish.panigrahi@protonmail.com>
" Last Change:  2020-11-20
" Version:      1
" URL:          https://www.github.com/paniash/dotvim


" Quit if a syntax file is already loaded.
if exists("b:current_syntax")
    finish
endif

let s:normal_contains_list = [
    \ 'TeXGroup', 'TeXCommandWord', 'TeXCommandSymbol', 'TeXAccent',
    \ 'TeXComment', 'TeXMathInline', 'TeXMacroDefinition', 'TeXMacroArgument',
    \ 'TeXReferenceCommand', 'TeXTextModified', 'TeXBeginEnd',
\ ]
let s:normal_contains = join(s:normal_contains_list, ',')

" TeX keyword commands can only contain alphabetic characters and the leader.
syntax iskeyword \,*,a-z,A-Z

" Super generic catch-alls.
syntax match TeXCommandSymbol '\v\\[a-zA-Z0-9#%$]'
syntax match TeXCommandWord   '\v\\[a-zA-Z]+\*?'
syntax match TeXCommandAtMacro '\v\\[a-zA-Z]*\@[a-zA-Z@]*\*?'
syntax match TeXAccent #\v\\[`'"~=.].#
syntax match TeXAccent #\v\\[bcdktuvH]\s+\S#
syntax match TeXComment #\v\%.*$#
syntax match TeXCommandSymbol '\v\\[\{\}]'

syntax match TeXImport #\v\\(documentclass|usepackage)>#
    \ skipwhite nextgroup=TeXImportOptions,TeXImportPackages
syntax region TeXImportOptions matchgroup=TeXGroupDelimiter start='\[' end=']'
    \ transparent
    \ contained contains=TeXImportOption
    \ skipwhite nextgroup=TeXImportPackages
syntax region TeXImportPackages matchgroup=TeXGroupDelimiter start='{' end='}'
    \ transparent
    \ contained contains=TeXImportPackage
syntax match TeXImportOption #\v[a-zA-Z\&0-9]+# contained
    \ skipwhite nextgroup=TeXImportEquals
syntax match TeXImportEquals '=' contained
    \ skipwhite nextgroup=TeXImportOptionValue
syntax match TeXImportOptionValue #\v[a-zA-Z\&0-9]+# contained
syntax match TeXImportPackage #\v\w+# contained

syntax match TeXBeginEnd #\v\\(begin|end)>#
    \ skipwhite nextgroup=TeXBeginEndGroup
execute 'syntax region TeXBeginEndGroup matchgroup=TeXBeginEndGroupDelimiter'
    \ . ' start=#\v\{# skip=#\\\\|\\\}# end=#\v\}#'
    \ . ' contained contains=' . s:normal_contains

"" Match TeX lengths
let s:tex_single_length='\v[-+]?(\d*\.?\d+|\d+\.?\d*)\s*(pt|mm|cm|in|ex|em|bp|pc|dd|cc|nd|nc|sp)'
" Length regex: '<len>( plus <len>( minus <len>)?| minus <len>( plus <len>)?)?'
" where a space stands for a non-zero number of whitespace characters and
" '<len>' stands for the `s:tex_single_length` regex.

" The first regex matches an optional plus follow by an optional minus, so the
" second one only needs to match the case where the plus follows the minus.
execute 'syntax match TeXLength #'
    \ . s:tex_single_length
    \ . '(\s+plus\s+' . s:tex_single_length . ')?'
    \ . '(\s+minus\s+' . s:tex_single_length . ')?'
    \ . '#'
execute 'syntax match TeXLength #'
    \ . s:tex_single_length
    \ . '\s+minus\s+' . s:tex_single_length . '\s+plus\s+' . s:tex_single_length
    \ . '#'

"" Match LaTeX sectioning commands as keywords.
let s:section_commands = ['section', 'subsection', 'subsubsection', 'paragraph',
                         \'chapter', 'part']
execute 'syntax keyword TeXSection \\' . join(s:section_commands, ' \\')
execute 'syntax keyword TeXSection \\' . join(s:section_commands, '* \\') . '*'

let s:letters = [
    \ 'alpha', 'beta', 'gamma', 'delta', 'epsilon', 'zeta', 'eta', 'theta',
    \ 'iota', 'kappa', 'lambda', 'mu', 'nu', 'xi', 'pi', 'rho', 'sigma',
    \ 'tau', 'upsilon', 'phi', 'chi', 'psi', 'omega',
    \ 'Gamma', 'Delta', 'Theta', 'Lambda', 'Xi', 'Pi', 'Sigma', 'Upsilon',
    \ 'Phi', 'Psi', 'Omega',
    \ 'varepsilon', 'vartheta', 'varrho', 'varphi', 'varpi', 'varsigma',
    \ 'varGamma', 'varDelta', 'varTheta', 'varLambda', 'varXi', 'varPi',
    \ 'varSigma', 'varUpsilon', 'varPhi', 'varPsi', 'varOmega',
    \ 'aleph', 'beth', 'gimel', 'daleth',
    \ 'ell', 'hbar', 'imath', 'jmath', 'infty',
\ ]
execute 'syntax match TeXMathLetter'
    \ . ' #\v\\(' . join(s:letters, '|') . ')[^a-zA-Z]#me=e-1'
execute 'syntax match TeXMathLetter'
    \ . ' #\v\\(' . join(s:letters, '|') . ')$#'

syntax match TeXAlignment '&'

syntax match TeXMacroDefinition #\v\\(def|let)[^a-zA-Z]#me=e-1
syntax match TeXMacroDefinition #\v\\(re)?newcommand\*?[^[a-zA-Z]#me=e-1
syntax match TeXMacroDefinition #\v\\newlength[^a-zA-Z]#me=e-1
syntax match TeXMacroArgument '\v#{1,3}\d'

syntax match TeXSizeModifier
    \ #\v\\([bB]igg?[rl]?|left|right)([|()]|\[|\]|\\\{|\\\}|\\[rl]angle|\.)#

syntax region TeXGroup matchgroup=TeXGroupDelimiter
    \ start=#\v\{# skip=#\\\\|\\\}# end=#\v\}#
    \ transparent
syntax region TeXGroup matchgroup=TeXGroupDelimiter
    \ start=#\v\[# skip=#\\\\|\\\]# end=#\v\]#
    \ transparent keepend
syntax region TeXGroup matchgroup=TeXGroupDelimiter
    \ start=#\v\\begingroup># skip=#\\\\# end=#\v\\endgroup>#
    \ transparent

"""" Math mode highlights
let s:math_contains_list = [
    \ 'TeXGroup', 'TeXAlignment', 'TeXCommandWord', 'TeXCommandSymbol',
    \ 'TeXComment', 'TeXSizeModifier', 'TeXReferenceCommand', 'TeXMathLetter',
    \ 'TeXSuperSubscript', 'TeXMathInnerText', 'TeXBeginEnd',
\ ]
let s:math_contains = join(s:math_contains_list, ',')
function! s:make_math_command(start, finish)
    execute 'syntax region TeXMathDisplay matchgroup=TeXMathDelimiter'
        \ . ' start=' . a:start
        \ . ' end=' . a:finish
        \ . ' contains=' . s:math_contains
endfunction
function! s:make_math_environment(environment)
    call s:make_math_command('#\v\\begin\{' . a:environment . '\}#',
                            \'#\v\\end\{' . a:environment . '\}#')
endfunction

execute 'syntax region TeXMathInline'
    \ . ' matchgroup=TeXMathDelimiter'
    \ . ' start="\$" skip="\\\\|\\\$" end="\$"'
    \ . ' contains=' . s:math_contains

let s:math_environments = [
    \ 'equation', 'equation\*', 'align', 'align\*', 'multline', 'multline\*',
    \ 'gather', 'gather\*', 'alignat', 'alignat\*', 'flalign', 'flalign\*',
    \ 'split', 'eqnarray', 'eqnarray\*'
\ ]
for environment in s:math_environments
    call s:make_math_environment(environment)
endfor
call s:make_math_command('#\v\\\[#', '#\v\\\]#')
call s:make_math_command('#\v\$\$#', '#\v\$\$#')

syntax match TeXSuperSubscript #\v[_^]# contained
    \ skipwhite nextgroup=TeXSuperSubscriptSingle,TeXSuperSubscriptContents
syntax match TeXSuperSubscriptSingle #\v[^\{\\]# contained
execute 'syntax region TeXSuperSubscriptContents'
    \ . ' matchgroup=TeXSuperSubscriptSingle'
    \ . ' start=#\v\{# skip=#\\\\|\\\}# end=#\v\}#'
    \ . ' transparent contained'
    \ . ' contains=' . s:math_contains

execute 'syntax region TeXMathInnerText'
    \ . ' matchgroup=TeXTextType'
    \ . ' start=#\v\\(((short)?inter)?text|mathrm|mathit)\{#'
    \ . ' skip=#\\\\|\\\}#'
    \ . ' end=#\v\}#'
    \ . ' contains=' . s:normal_contains
    \ . ' contained'

" Normal-mode text modifiers which take one argument (typically the text they
" modify, but we can co-opt this for the `\color` command too.
let s:normal_text_modifiers_list = [
    \ 'textit', 'textbf', 'textsc', 'texttt',
    \ 'textsuperscript', 'textsubscript', 'color',
    \ 'emph'
\ ]
execute 'syntax region TeXTextModified'
    \ . ' matchgroup=TeXTextType'
    \ . ' start=#\v\\(' . join(s:normal_text_modifiers_list, '|') . ')\{#'
    \ . ' skip=#\\\\|\\\}#'
    \ . ' end=#\v\}#'
    \ . ' contains=' . s:normal_contains

syntax match TeXMainMatterDelimiter #\v\\(begin|end)\{document\}#

syntax match TeXReferenceCommand
    \ #\v\\(label|(eq|[cC])?ref|cite[tp]?\*?)>#
    \ skipwhite nextgroup=TeXReferenceGroup
syntax region TeXReferenceGroup matchgroup=TeXReferenceDelimiter
    \ start=#\v\{# skip=#\\\\|\\\}# end=#\v\}#
    \ transparent contained
    \ contains=TeXReference,TeXReferenceType
syntax match TeXReference #\v[a-zA-Z\-0-9]+# contained
syntax match TeXReferenceType #\v[a-zA-Z]*:# nextgroup=TeXReference contained

" Set up highlighting.
highlight! link TeXCommandWord          Function
highlight! link TeXCommandSymbol        Special
highlight! link TeXCommandAtMacro       Special
highlight! link TeXAccent               Special
highlight! link TeXComment              Comment
highlight! link TeXLength               Number
highlight! link TeXSection              Statement
highlight! link TeXGroupDelimiter       Delimiter

highlight! link TeXBeginEnd             TeXGroupDelimiter
highlight! link TeXBeginEndGroup        Normal
highlight! link TeXBeginEndGroupDelimiter TeXGroupDelimiter

highlight! link TeXMacroDefinition      Statement
highlight! link TeXMacroArgument        Special
highlight! link TeXMainMatterDelimiter  PreProc

highlight! link TeXMathInline           TeXMathMode
highlight! link TeXMathDisplay          TeXMathMode
highlight! link TeXMathLetter           TeXMathConstant
highlight! link TeXMathDelimiter        TeXTextType
highlight! link TeXSizeModifier         Statement
highlight! link TeXSuperSubscript       TeXMathDelimiter
highlight! link TeXSuperSubscriptSingle TeXSuperSubscript
highlight! link TeXAlignment            Special

highlight! link TeXTextType             Type

highlight! link TeXReferenceCommand     TeXMathConstant
highlight! link TeXReferenceType        TeXReference
highlight! link TeXReference            Comment
highlight! link TeXReferenceDelimiter   TeXMathConstant

highlight! link TeXImport               PreProc
highlight! link TeXImportOption         TeXOption
highlight! link TeXImportEquals         Operator
highlight! link TeXImportOptionValue    Normal
highlight! link TeXImportPackage        Namespace

" Mark that we've now loaded the TeX syntax.
let b:current_syntax="tex"

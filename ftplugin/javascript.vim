autocmd BufWritePost <buffer> Neomake
let g:neomake_javascript_enabled_makers = ['standard', 'jshint', 'eslint', 'jscs', 'flow']
:call filter(g:neomake_javascript_enabled_makers, 'neomake#utils#Exists(v:val)')

set foldmethod=syntax

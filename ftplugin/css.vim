let g:neomake_css_csslint_maker = {
    \ 'args': ['--quiet', '--format=compact'],
    \ 'errorformat': '%f: line %l\, col %c\, %t%*[a-zA-Z] - %m',
    \ }
let g:neomake_css_enabled_makers = ['csslint']

autocmd BufWritePost <buffer> Neomake

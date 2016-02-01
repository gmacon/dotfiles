setlocal tw=79 ts=8 sts=4 sw=4 et fo-=t omnifunc=jedi#completions
autocmd BufWritePost <buffer> Neomake

let g:neomake_python_enabled_makers = ['python', 'frosted', 'pylama', 'pylint']
:call filter(g:neomake_python_enabled_makers, 'neomake#utils#Exists(v:val)')

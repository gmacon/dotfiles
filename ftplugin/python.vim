setlocal tw=79 ts=8 sts=4 sw=4 et fo-=t
autocmd BufWritePost <buffer> Neomake

let g:neomake_python_enabled_makers = ['python', 'flake8', 'pylama', 'pylint']
:call filter(g:neomake_python_enabled_makers, 'neomake#utils#Exists(v:val)')

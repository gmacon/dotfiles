setlocal tw=79 ts=8 sts=4 sw=4 et fo-=t

augroup ftplugin_python
    autocmd!
    autocmd BufWritePre <buffer> Neoformat
augroup END

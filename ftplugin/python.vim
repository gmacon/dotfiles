setlocal tw=79 ts=8 sts=4 sw=4 et fo-=t
autocmd BufWritePre <buffer> Black
autocmd BufWritePost <buffer> Neomake

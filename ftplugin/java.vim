setlocal omnifunc=javacomplete#Complete
autocmd BufWritePost <buffer> Neomake! mvn

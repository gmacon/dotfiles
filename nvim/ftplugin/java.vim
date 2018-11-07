setlocal omnifunc=javacomplete#Complete
autocmd BufWritePost <buffer> silent :EnTypeCheck
nnoremap <unique> <buffer> <leader>d :EnDeclaration<CR>
nnoremap <unique> <buffer> <leader>h :EnDocBrowse<CR>

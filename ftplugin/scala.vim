if !exists('b:loaded_gmacon_scala')
    let b:loaded_gmacon_scala = 1
    autocmd BufWritePost <buffer> silent :EnTypeCheck
    nnoremap <unique> <buffer> <leader>d :EnDeclaration<CR>
    nnoremap <unique> <buffer> <leader>h :EnDocBrowse<CR>
    nnoremap <unique> <buffer> <leader>t :EnType<CR>
    xnoremap <unique> <buffer> <leader>t :EnType selection<CR>
endif

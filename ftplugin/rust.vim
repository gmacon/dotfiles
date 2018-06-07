autocmd BufWritePost <buffer> Neomake! cargo
autocmd BufWritePost <buffer> normal! zv

nnoremap <leader>d <Plug>(rust-def)
nnoremap <leader>h <Plug>(rust-doc)

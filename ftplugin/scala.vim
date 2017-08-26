autocmd BufWritePost <buffer> silent :EnTypeCheck
nnoremap <unique> <buffer> <leader>d :EnDeclaration<CR>
nnoremap <unique> <buffer> <leader>h :EnDocBrowse<CR>
nnoremap <unique> <buffer> <leader>t :EnType<CR>
xnoremap <unique> <buffer> <leader>t :EnType selection<CR>

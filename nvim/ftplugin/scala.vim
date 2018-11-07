setlocal foldmethod=syntax
if !exists('b:loaded_gmacon_scala')
    let b:loaded_gmacon_scala = 1
    nnoremap <unique> <buffer> <leader>d :EnDeclaration<CR>
    nnoremap <unique> <buffer> <leader>h :EnDocBrowse<CR>
    nnoremap <unique> <buffer> <leader>i :EnSuggestImport<CR>
    nnoremap <unique> <buffer> <leader>I :EnOrganizeImports<CR>
    nnoremap <unique> <buffer> <leader>t :EnType<CR>
    xnoremap <unique> <buffer> <leader>t :EnType selection<CR>
    nnoremap <unique> <buffer> <leader>r :EnRename<CR>
endif

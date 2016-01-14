setlocal ts=3 sts=3 sw=3 noexpandtab nolist
setlocal foldmethod=indent foldnestmax=1
let g:go_bin_path = expand("~/.gotools")
autocmd BufWritePost <buffer> Neomake

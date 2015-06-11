let g:neomake_puppet_puppetlint_maker = {
      \ 'exe': 'puppet-lint',
      \ 'args': ['--log-format', '"%{path}:%{line}:%{column}:%{kind}:[%{check}] %{message}"'],
      \ 'errorformat': '"%f:%l:%c:%t%*[a-zA-Z]:%m"',
      \ }
let g:neomake_puppet_puppet_maker = {
      \ 'args': ['parser', 'validate'],
      \ 'errorformat': '%t%*[a-zA-Z]: %m at %f:%l',
      \ }
let g:neomake_puppet_enabled_makers = ['puppetlint', 'puppet']
autocmd BufWritePost <buffer> Neomake

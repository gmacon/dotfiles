autocmd BufWritePre <buffer> normal mp | %!rustup run stable rustfmt | normal `p

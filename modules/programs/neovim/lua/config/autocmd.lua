vim.cmd([[
]])
-- augroup fmt
--     autocmd!
--     autocmd BufWritePre * undojoin | Neoformat
-- augroup END



-- from: https://stackoverflow.com/a/21406581
-- augroup collumnLimit
--   autocmd!
--   autocmd BufEnter,WinEnter,FileType scala,java
--         \ highlight CollumnLimit ctermbg=DarkGrey guibg=DarkGrey
--   let collumnLimit = 79 " feel free to customize
--   let pattern =
--         \ '\%<' . (collumnLimit+1) . 'v.\%>' . collumnLimit . 'v'
--   autocmd BufEnter,WinEnter,FileType scala,java
--         \ let w:m1=matchadd('CollumnLimit', pattern, -1)
-- augroup END

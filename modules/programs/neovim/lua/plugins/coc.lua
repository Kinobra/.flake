vim.cmd([[
" confirm completion of first item
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
" To make <cr> select the first completion item and confirm the completion when no item has been selected
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

" use tab to navigate completion list
inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
]])

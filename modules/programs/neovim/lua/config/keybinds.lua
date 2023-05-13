vim.cmd([[
" Quit on pressing q
nnoremap  <Leader>q       :q<CR>
nnoremap  q               :Dashboard<CR>

" Save with SPC-f-s"
nnoremap  <silent>  <Leader>fs      :w<CR>

" Floaterm
nmap      <leader>t :FloatermNew<CR>
nmap      <leader>g :FloatermNew gitui<CR>

" presentation mode
inoremap  <Left> <NOP>
inoremap  <Right> <NOP>

" noremap   <Left> :silent bp<CR> :redraw!<CR>
" noremap   <Right> :silent bn<CR> :redraw!<CR>
nnoremap  <Left>    <Plug>(unimpaired-directory-previous)
nnoremap  <Right>   <Plug>(unimpaired-directory-next)
" nnoremap <key> :args `ls\|sort -g`<CR>
nmap      <F5> :call ToggleListChars()<CR>
nmap      <F2> :call DisplayPresentationBoundaries()<CR>
nmap      <F3> :call FindExecuteCommand()<CR>

" makes Ascii art font
"" -f standard
"" -f small
nmap      <leader>T :.!toilet -w 200<CR>
" makes Ascii border
nmap      <leader>1 :.!toilet -w 200 -f term -F border<CR>
" capitalize titles
nmap      <leader>C :.!capitalize-title -<CR>
" center a line
nmap      <leader>c :center<CR>

let g:listcharsDisplayed = 1
function! ToggleListChars()
  if g:listcharsDisplayed
    set listchars=tab:\ \ 
    set norelativenumber nonumber nohidden noshowcmd noshowmode nocursorline noruler
    let g:listcharsDisplayed = 0
  else
    set listchars=eol:¬,tab:>=,trail:~,extends:>,precedes:<,space:·
    set relativenumber number hidden showcmd showmode cursorline ruler
    let g:listcharsDisplayed = 1
  endif
endfunction

let g:presentationBoundsDisplayed = 0
function! DisplayPresentationBoundaries()
  if g:presentationBoundsDisplayed
    match
    set colorcolumn=0
    let g:presentationBoundsDisplayed = 0
  else
    highlight lastoflines ctermbg=darkred guibg=darkred
    match lastoflines /\%23l/
    set colorcolumn=80
    let g:presentationBoundsDisplayed = 1
  endif
endfunction

function! FindExecuteCommand()
  let line = search('\S*!'.'!:.*')
  if line > 0
    let command = substitute(getline(line), "\S*!"."!:*", "", "")
    execute "silent !". command
    execute "normal gg0"
    redraw
  endif
endfunction
]])

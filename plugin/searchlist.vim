" nvim-searchlist - adds a searchlist to Neovim.
"
" Maintainer: Joe Ellis <joechrisellis@gmail.com>
" Version:    0.1.0
" License:    Same terms as Vim itself (see |license|)
" Location:   plugin/searchlist.vim
" Website:    https://github.com/joechrisellis/nvim-searchlist
"
" Use this command to get help on nvim-searchlist:
"
"     :help searchlist

if exists("g:loaded_searchlist")
  finish
endif
let g:loaded_searchlist = 1

" Hook AddEntry in to the common search commands.
function! s:CreateSearchBindings() abort
  for l:searchcmd in ["/", "?", "*", "#", "g*", "g#", "gd", "gD"]
    exe "nnoremap <silent> " . l:searchcmd . " :call searchlist#AddEntry()<cr>" . l:searchcmd
  endfor
endfunction

" Create bindings for jumping back and forth in the searchlist.
function! s:CreateJumpBindings() abort
  nnoremap <silent> g\ :call searchlist#JumpBackwards()<cr>
  nnoremap <silent> g/ :call searchlist#JumpForwards()<cr>
endfunction

function! s:CreateAllBindings() abort
  call s:CreateSearchBindings()
  call s:CreateJumpBindings()
endfunction

" Users can change this if they want to set their own bindings or if they
" already have bindings for the common search commands and want to tie them in
" with nvim-searchlist.
let g:searchlist_bindings = "all"

if g:searchlist_bindings ==? "all"
  call s:CreateAllBindings()
elseif g:searchlist_bindings ==? "search_only"
  call s:CreateSearchBindings()
elseif g:searchlist_bindings ==? "jump_only"
  call s:CreateJumpBindings()
endif

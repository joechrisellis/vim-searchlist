" vim-searchlist - adds a searchlist to Vim/Neovim.
"
" Maintainer:   Joe Ellis <joechrisellis@gmail.com>
" Version:      0.1.0
" License:      Same terms as Vim itself (see |license|)
" Location:     plugin/searchlist.vim
" Website:      https://github.com/joechrisellis/vim-searchlist
"
" Use this command to get help on vim-searchlist:
"
"     :help searchlist

if exists("g:loaded_searchlist")
    finish
endif
let g:loaded_searchlist = 1

" Hook AddEntry in to the common search commands.
function! s:CreateSearchMaps() abort
    for l:searchcmd in ["/", "?", "*", "#", "g*", "g#"]
        exe "nnoremap " . l:searchcmd . " :<C-u>call searchlist#AddEntry()<cr>" . l:searchcmd
    endfor
endfunction

" Create maps for jumping back and forth in the searchlist.
function! s:CreateJumpMaps() abort
    nnoremap <silent> g\ :<C-u>call searchlist#JumpBackwards()<cr>
    nnoremap <silent> g/ :<C-u>call searchlist#JumpForwards()<cr>
endfunction

function! s:CreateAllMaps() abort
    call s:CreateSearchMaps()
    call s:CreateJumpMaps()
endfunction

" Users can change this if they want to set their own maps or if they already
" have maps for the common search commands and want to tie them in with
" vim-searchlist.
if !exists("g:searchlist_maps")
    let g:searchlist_maps = "all"
endif

if g:searchlist_maps ==? "all"
    call s:CreateAllMaps()
elseif g:searchlist_maps ==? "search_only"
    call s:CreateSearchMaps()
elseif g:searchlist_maps ==? "jump_only"
    call s:CreateJumpMaps()
endif

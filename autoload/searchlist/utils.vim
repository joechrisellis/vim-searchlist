" nvim-searchlist - adds a searchlist to Neovim.
"
" Maintainer:   Joe Ellis <joechrisellis@gmail.com>
" Version:      0.1.0
" License:      Same terms as Vim itself (see |license|)
" Location:     plugin/searchlist.vim
" Website:      https://github.com/joechrisellis/nvim-searchlist
"
" Use this command to get help on nvim-searchlist:
"
"     :help searchlist

" Converts zero-based values to one-based values. YES, this is an extremely
" simple function. However, reading searchlist#utils#ZeroBasedToOneBased(x)
" signals intent far better than just x + 1.
function! searchlist#utils#ZeroBasedToOneBased(num)
    return a:num + 1
endfunction

" Converts one-based values to zero-based values. YES, this is an extremely
" simple function. However, reading searchlist#utils#OneBasedToZeroBased(x)
" signals intent far better than just x - 1.
function! searchlist#utils#OneBasedToZeroBased(num)
    return a:num - 1
endfunction

" Performs a 'rotating append' to a list -- i.e. if the list's maximum
" capacity is exceeded after performing the append, the elements at the lower
" indices are removed so that the list is not over capacity.
function! searchlist#utils#RotatingAppend(list, elem, max_capacity) abort
    let l:new_list = a:list
    call add(l:new_list, a:elem)

    let l:capacity = len(l:new_list)
    let l:excess = l:capacity - a:max_capacity

    let l:removed_elements = []
    if l:excess >= 1
        let l:removed_elements = l:new_list[:l:excess - 1]
        let l:new_list = l:new_list[l:excess:]
    endif

    return [l:new_list, l:removed_elements]
endfunction

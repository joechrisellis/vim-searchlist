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

" 100 is chosen for consistency with the jumplist.
let g:searchlist_max_capacity = 100

let s:mark_ns = searchlist#mark#CreateNamespace("searchlist")

" Simple wrapper around searchlist#mark#DelMark that deletes a list of ids.
function! s:BufDelExtmarks(buffer, mark_ns, ids) abort
    for l:id in a:ids
        call searchlist#mark#DelMark(a:buffer, a:mark_ns, l:id)
    endfor
endfunction

" Adds the current cursor position as an entry to the searchlist.
function! searchlist#AddEntry() abort
    let b:searchlist = get(b:, "searchlist", [])
    let b:searchlist_index = get(b:, "searchlist_index", 0)

    let [l:row, l:col] = [line("."), col(".")]

    " Remove everything beyond our current searchlist index.
    let l:ids_to_delete = b:searchlist[b:searchlist_index + 1:]
    call s:BufDelExtmarks(0, s:mark_ns, l:ids_to_delete)
    let b:searchlist = b:searchlist[:b:searchlist_index]

    " If the searchlist is not empty, check that the new top of the searchlist
    " is not the same as the position we're currently at. If it is, we can
    " return early to prevent adding duplicate entries to the searchlist.
    if !empty(b:searchlist)
        let l:last_id = b:searchlist[-1]
        let [l:last_row, l:last_col] = searchlist#mark#GetMark(0, s:mark_ns, l:last_id)

        if l:row == l:last_row && l:col == l:last_col
            let b:searchlist_index = len(b:searchlist)
            return
        endif
    endif

    " Create a new extmark and add it as a new entry.
    let l:id = searchlist#mark#SetMark(
                \ 0,
                \ s:mark_ns,
                \ l:row,
                \ l:col)
    let [b:searchlist, l:removed_elements] =
                \ searchlist#utils#RotatingAppend(b:searchlist, l:id, g:searchlist_max_capacity)
    let b:searchlist_index = len(b:searchlist)

    " Remove anything that was removed from the searchlist (because it didn't
    " fit within the max capacity).
    call s:BufDelExtmarks(0, s:mark_ns, l:removed_elements)
endfunction

" Jump backwards one position in the jumplist. Returns true if a jump was
" made, false otherwise.
function! s:JumpBackwardsOnce() abort
    let b:searchlist_index = get(b:, "searchlist_index", 0)
    if b:searchlist_index <= 0
        return v:false
    endif

    let b:searchlist_index -= 1

    let l:id = b:searchlist[b:searchlist_index]
    let [l:row, l:col] = searchlist#mark#GetMark(0, s:mark_ns, l:id)

    " Move to the entry.
    " NOTE: cursor(...) unfortunately does not modify the jumplist. It would
    "       be nice to find an alternative here.
    call cursor(l:row, l:col)

    return v:true
endfunction

" Jump backwards count position in the jumplist.
function! searchlist#JumpBackwards() abort
    let l:i = 0
    while l:i < v:count1
        let l:made_jump = s:JumpBackwardsOnce()
        if !l:made_jump
            break
        endif
        let l:i += 1
    endwhile
endfunction

" Jump forwards one position in the jumplist. Returns true if a jump was made,
" false otherwise.
function! s:JumpForwardsOnce() abort
    let b:searchlist = get(b:, "searchlist", [])
    let b:searchlist_index = get(b:, "searchlist_index", 0)
    if b:searchlist_index >= len(b:searchlist) - 1
        return v:false
    endif

    let b:searchlist_index += 1

    let l:id = b:searchlist[b:searchlist_index]
    let [l:row, l:col] = searchlist#mark#GetMark(0, s:mark_ns, l:id)

    " Move to the entry.
    " NOTE: cursor(...) unfortunately does not modify the jumplist. It would
    "       be nice to find an alternative here.
    call cursor(l:row, l:col)

    return v:true
endfunction

" Jump forwards one position in the jumplist.
function! searchlist#JumpForwards() abort
    let l:i = 0
    while l:i < v:count1
        let l:made_jump = s:JumpForwardsOnce()
        if !l:made_jump
            break
        endif
        let l:i += 1
    endwhile
endfunction

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

let s:mark_ns = nvim_create_namespace("searchlist")

function! searchlist#AddEntry() abort
    let b:searchlist = get(b:, "searchlist", [])
    let b:searchlist_index = get(b:, "searchlist_index", 0)

    " Remove everything beyond our current searchlist index.
    let b:searchlist = b:searchlist[:b:searchlist_index]

    if b:searchlist_index == len(b:searchlist)
        let b:searchlist_index += 1
    else
        let b:searchlist_index += 2
    endif

    " Add the new entry.
    let l:row = line(".")
    let l:col = col(".")

    let b:searchlist = get(b:, "searchlist", [])

    let l:id = nvim_buf_set_extmark(0, s:mark_ns, l:row - 1, l:col - 1, {})
    call add(b:searchlist, l:id)
endfunction

function searchlist#JumpBackwards() abort
    let b:searchlist_index = get(b:, "searchlist_index", 0)
    if b:searchlist_index <= 0
        return
    endif

    let b:searchlist_index -= 1

    let l:id = b:searchlist[b:searchlist_index]
    let [l:row, l:col] = nvim_buf_get_extmark_by_id(0, s:mark_ns, l:id, {})

    " Move to the entry.
    call cursor(l:row + 1, l:col + 1)
endfunction

function searchlist#JumpForwards() abort
    let b:searchlist = get(b:, "searchlist", [])
    let b:searchlist_index = get(b:, "searchlist_index", 0)
    if b:searchlist_index >= len(b:searchlist) - 1
        return
    endif

    let b:searchlist_index += 1

    let l:id = b:searchlist[b:searchlist_index]
    let [l:row, l:col] = nvim_buf_get_extmark_by_id(0, s:mark_ns, l:id, {})

    " Move to the entry.
    call cursor(l:row + 1, l:col + 1)
endfunction

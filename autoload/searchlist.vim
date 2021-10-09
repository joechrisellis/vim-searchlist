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

let s:mark_ns = nvim_create_namespace("searchlist")

" Converts zero-based values to one-based values. YES, this is an extremely
" simple function. However, reading s:ZeroBasedToOneBased(x) signals intent
" far better than just x + 1.
function! s:ZeroBasedToOneBased(num)
    return a:num + 1
endfunction

" Converts zero-based values to one-based values. YES, this is an extremely
" simple function. However, reading s:ZeroBasedToOneBased(x) signals intent
" far better than just x + 1.
function! s:OneBasedToZeroBased(num)
    return a:num - 1
endfunction

function searchlist#Debug() abort
    echo b:searchlist_index . " " .  join(b:searchlist)
endfunction

function! searchlist#AddEntry() abort
    let b:searchlist = get(b:, "searchlist", [])
    let b:searchlist_index = get(b:, "searchlist_index", 0)

    let l:row = line(".")
    let l:col = col(".")

    " Remove everything beyond our current searchlist index.
    let b:searchlist = b:searchlist[:b:searchlist_index]

    if !empty(b:searchlist)
        let l:last_id = b:searchlist[-1]
        let [l:last_row, l:last_col] = nvim_buf_get_extmark_by_id(0, s:mark_ns, l:last_id, {})
        if l:row == s:ZeroBasedToOneBased(l:last_row)
                    \ && l:col == s:ZeroBasedToOneBased(l:last_col)
            return
        endif
    endif

    if b:searchlist_index == len(b:searchlist)
        let b:searchlist_index += 1
    else
        let b:searchlist_index += 2
    endif

    " Add the new entry.
    let b:searchlist = get(b:, "searchlist", [])

    let l:id = nvim_buf_set_extmark(
                \ 0,
                \ s:mark_ns,
                \ s:OneBasedToZeroBased(l:row),
                \ s:OneBasedToZeroBased(l:col),
                \ {})
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
    call cursor(s:ZeroBasedToOneBased(l:row),
                \ s:ZeroBasedToOneBased(l:col))
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
    call cursor(s:ZeroBasedToOneBased(l:row),
                \ s:ZeroBasedToOneBased(l:col))
endfunction

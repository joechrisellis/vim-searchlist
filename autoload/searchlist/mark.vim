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

" WHAT IS THIS FILE?
" Both Neovim and Vim have support for marks that move with the text. Neovim
" calls these extended marks (`:help extmarks`, Neovim only), and Vim calls
" them text properties (`:help text-properties`).
" This file offers an interface that acts as a compatibility layer, providing
" a subset of the functionality implemented by extmarks and textprops
" necessary for implementing the searchlist.

let s:err_unsupported_version = "Your version of Vim is unsupported."

let s:id = 0

function! s:GetId() abort
    let l:id = s:id
    let s:id += 1
    return l:id
endfunction

" ----------------------------------------------------------------------------

function! s:NvimCreateNamespace(name) abort
    let l:ns_id = nvim_create_namespace(a:name)
    return l:ns_id
endfunction

function! s:VimCreateNamespace(name) abort
    call prop_type_add('searchlist', {})
    let l:some_big_number = 51773
    return l:some_big_number
endfunction

function! searchlist#mark#CreateNamespace(name) abort
    if has("nvim")
        let l:retval = s:NvimCreateNamespace(a:name)
    elseif has("textprop")
        let l:retval = s:VimCreateNamespace(a:name)
    else
        throw s:err_unsupported_version
    endif
    return l:retval
endfunction

" ----------------------------------------------------------------------------

function! s:NvimSetMark(buffer, ns_id, row, col) abort
    let l:id = nvim_buf_set_extmark(
                \ 0,
                \ a:ns_id,
                \ searchlist#utils#OneBasedToZeroBased(a:row),
                \ searchlist#utils#OneBasedToZeroBased(a:col),
                \ {})
    return l:id
endfunction

function! s:VimSetMark(buffer, ns_id, row, col) abort
    let l:id = s:GetId()
    let l:namespaced_id = a:ns_id + l:id

    let l:props = {
                \ 'id' : l:namespaced_id,
                \ 'type': 'searchlist',
                \ }
    if a:buffer != 0
        let l:props['bufnr'] = a:buffer
    endif

    call prop_add(
                \ a:row,
                \ a:col,
                \ l:props)
    return l:id
endfunction

function! searchlist#mark#SetMark(buffer, ns_id, row, col) abort
    if has("nvim")
        let l:retval = s:NvimSetMark(a:buffer, a:ns_id, a:row, a:col)
    elseif has("textprop")
        let l:retval = s:VimSetMark(a:buffer, a:ns_id, a:row, a:col)
    else
        throw s:err_unsupported_version
    endif
    return l:retval
endfunction

" ----------------------------------------------------------------------------

function! s:NvimGetMark(buffer, ns_id, id) abort
    let [l:row, l:col] = nvim_buf_get_extmark_by_id(a:buffer,
                \ a:ns_id,
                \ a:id,
                \ {})
    return [
                \ searchlist#utils#ZeroBasedToOneBased(l:row),
                \ searchlist#utils#ZeroBasedToOneBased(l:col)]
endfunction

function! s:VimGetMark(buffer, ns_id, id) abort
    let l:id = a:ns_id + a:id
    let l:props = {'id' : l:id}
    if a:buffer != 0
        let l:props['bufnr'] = buffer
    endif

    " NOTE: Vim's API here is really dumb -- we have to search backwards, and
    "       if we don't find anything, we search forward.
    let l:prop = prop_find(l:props, 'b')
    if empty(l:prop)
        let l:prop = prop_find(l:props, 'f')
    endif
    return [l:prop["lnum"], l:prop["col"]]
endfunction

function! searchlist#mark#GetMark(buffer, ns_id, id) abort
    if has("nvim")
        let l:retval = s:NvimGetMark(a:buffer, a:ns_id, a:id)
    elseif has("textprop")
        let l:retval = s:VimGetMark(a:buffer, a:ns_id, a:id)
    else
        throw s:err_unsupported_version
    endif
    return l:retval
endfunction

" ----------------------------------------------------------------------------

function! s:NvimDelMark(buffer, ns_id, id) abort
    call nvim_buf_del_extmark(a:buffer, a:ns_id, a:id)
endfunction

function! s:VimDelMark(buffer, ns_id, id) abort
    let l:id = a:ns_id + a:id
    let l:props = {'id' : l:id}
    if a:buffer != 0
        let l:props['bufnr'] = a:buffer
    endif

    call prop_remove(l:props)
endfunction

function! searchlist#mark#DelMark(buffer, ns_id, id) abort
    if has("nvim")
        let l:retval = s:NvimDelMark(a:buffer, a:ns_id, a:id)
    elseif has("textprop")
        let l:retval = s:VimDelMark(a:buffer, a:ns_id, a:id)
    else
        throw s:err_unsupported_version
    endif
    return l:retval
endfunction

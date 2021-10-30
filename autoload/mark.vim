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

" WHAT IS THIS FILE?
" Both Neovim and Vim have support for marks that move with the text. Neovim
" calls these extended marks (`:help extmarks`, Neovim only), and Vim calls
" them text properties (`:`).
" This file provides an interface that acts as a compatibility layer.

function! s:NvimCreateNamespace(name) abort
    " TODO(josephellis):
endfunction

function! s:VimCreateNamespace() abort
    " TODO(josephellis):
endfunction

function! mark#CreateNamespace(name) abort
    " TODO(josephellis):
endfunction

" ----------------------------------------------------------------------------

function! s:NvimSetMark() abort
    " TODO(josephellis):
endfunction

function! s:VimSetMark() abort
    " TODO(josephellis):
endfunction

function! mark#SetMark() abort
    " TODO(josephellis):
endfunction

" ----------------------------------------------------------------------------

function! s:NvimGetMark() abort
    " TODO(josephellis):
endfunction

function! s:VimGetMark() abort
    " TODO(josephellis):
endfunction

function! mark#GetMark() abort
    " TODO(josephellis):
endfunction

" ----------------------------------------------------------------------------

function! s:NvimDelMark() abort
    " TODO(josephellis):
endfunction

function! s:VimDelMark() abort
    " TODO(josephellis):
endfunction

function! mark#DelMark() abort
    " TODO(josephellis):
endfunction

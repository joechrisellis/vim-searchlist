# vim-searchlist

![vim-searchlist demo](https://github.com/joechrisellis/vim-searchlist/blob/assets/assets/demo.gif)

Adds a 'searchlist' to Vim/Neovim. It acts like the jumplist, but instead of
storing jumps, stores the location where you last initiated a search.

Check out the [documentation](doc/searchlist.txt) for more.

## Rationale

Have you ever started searching for something with the `/`, `?`, `*`, `#`,
`g*`, `g#`, `gd`, or `gD` commands, then wanted to return to the cursor
position that you were in when you started the search?

(Neo)vim already has some built-in mechanisms that you can use for this:

- The jumplist (`:help jumplist`)
- Marks (`:help mark`)
- Using `<C-g>` and `<C-t>` when searching (`:help c_CTRL-G`)

All of these solutions have problems:

- The jumplist is too general -- a jump is command that normally moves the
  cursor several lines away (see `:help jump-motions`), and the standard set of
  search motions are jump commands. If you want to jump back to the position
  you were in when you started the search, you often have to jump back multiple
  positions in the jumplist.
- You could mark the current cursor position _before_ you start a search, but
  you have to actually remember to do this. Also, this technique doesn't work
  so well if you want to jump back to a few searches ago.
- Using `<C-g>` and  `<C-t>` while searching does not give you the full freedom
  to explore compared to what you get in normal mode.

This plugin introduces the idea of a 'searchlist'. Each time you initiate a new
search, the position is saved in the jumplist. You can walk backwards/forwards
over the saved position with `g\` and `g/` by default.

This means that you can freely explore using searches in a buffer and always
get back to where you started quickly.

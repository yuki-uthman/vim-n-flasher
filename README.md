# vim-nflasher

Let's make the n/N motion flashy!

![hlsearch on](hlsearch.gif)
![hlsearch off](nohlsearch.gif)

## Installation

* vim-plug
```viml
Plug 'yuki-uthman/vim-nflasher'
```

* vundle
```viml
Plugin 'yuki-uthman/vim-nflasher'
```

* minpac:
```viml
call minpac#add('yuki-uthman/vim-nflasher')

" for lazy loading
call minpac#add('yuki-uthman/vim-nflasher', { 'type': 'opt' })
packadd vim-nflasher
```

## Configuration

The default values are shown below:
```vimL
" the highlight group of the flash
let g:nflasher_highlight = 'IncSearch'

" to see all the available highlight groups
:h highlight 

" the duration of the flash (in milliseconds)
let g:nflasher_duration = 100

" the number of times to flash
let g:nflasher_repeat = 3

" setting this true keeps the flash on
" will be turned off when you move the cursor or enter insert mode
let g:nflasher_keep_flash = 0
```

If you want to define your own highlight group:
```vimL
" for terminal
" ctermfg as the font color
" ctermbg as the background color
highlight flasherColor ctermfg='White' ctermbg='Black'

" for gui
" guifg as the font color
" guibg as the background color
highlight flasherColor guifg='White' guibg='Black'

let g:nflasher_highlight = 'flasherColor'
```
The following colors are available in most systems:
  - Black
  - Brown
  - Gray
  - Blue
  - Green
  - Cyan
  - Red
  - Magenta
  - Yellow
  - White

To see more colors:
```vimL
h cterm-colors
h gui-colors
```

To set custom color using RGB:
```vimL
:highlight flasherColor guifg=#11f0c3 guibg=#ff00ff
```

## Licence

MIT Licence


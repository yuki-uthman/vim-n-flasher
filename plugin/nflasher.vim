" nFlasher - flashes the search matches
"
" Author: Yuki Yoshimine <yuki.uthman@gmail.com>
" Source: https://github.com/yuki-uthman/vim-nflasher


if exists("g:loaded_nflasher")
  finish
endif
let g:loaded_nflasher = 1

let s:save_cpo = &cpo
set cpo&vim

nnoremap <silent><Plug>(nflasher-n) n:call nflasher#flash()<CR>
nnoremap <silent><Plug>(nflasher-N) N:call nflasher#flash()<CR>

if !exists("g:nflasher_no_mappings") || ! g:nflasher_no_mappings
  nmap n <Plug>(nflasher-n)
  nmap N <Plug>(nflasher-N)
endif


let &cpo = s:save_cpo
unlet s:save_cpo

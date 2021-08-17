" n-flasher - flashes the search matches
"
" Author: Yuki Yoshimine <yuki.uthman@gmail.com>
" Source: https://github.com/yuki-uthman/vim-n-flasher


if exists("g:loaded_n_flasher")
  finish
endif
let g:loaded_n_flasher = 1

let s:save_cpo = &cpo
set cpo&vim

nnoremap <silent><Plug>(n-flasher) n:call flasher#n#flash()<CR>
nnoremap <silent><Plug>(N-flasher) N:call flasher#n#flash()<CR>

if !exists("g:n_flasher_no_mappings") || ! g:n_flasher_no_mappings
  nmap n <Plug>(n-flasher)
  nmap N <Plug>(N-flasher)
endif


let &cpo = s:save_cpo
unlet s:save_cpo

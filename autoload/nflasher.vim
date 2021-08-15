function! nflasher#n()
  call feedkeys('n', 'n')
  call s:flash()
endfunction

function! nflasher#N()
  call feedkeys('N', 'n')
  call s:flash()
endfunction

" for autocmd
function! nflasher#flash_off(mode) 
  if a:mode ==# 'n'
    let s:pos = match(getline('.'), @/, col('.') - 1) + 1
    if s:pos != col('.')
        call s:flash_off(0)
        call s:stop_toggle_timer(0)
    endif

  elseif a:mode ==# 'i'
    call s:flash_off(0)
    call s:stop_toggle_timer(0)
  endif
endfunction 

function! s:init_flash() "{{{

  return { 
        \'winid': 0,
        \'id': 0,
        \'state': 0,
        \'toggle_timer': 0 }

endfunction "}}}

function! s:flash_on(timer_id) "{{{

  " if it is only one char then invert color
  " let higroup = matchend(getline('.'), '\c'.@/, col('.')-1) == col('.')
  "             \ ? 'ErrorMsg' : s:user_config.highlight

  let winid = win_getid()
  let id = matchadd(s:user_config.highlight, '\%#'.@/) 

  let s:flash.winid = winid
  let s:flash.id = id
  let s:flash.state = 1
endfunction "}}}

function! s:flash_off(timer_id) "{{{
  if exists('s:flash') && s:flash.id > 0
    call matchdelete(s:flash.id, s:flash.winid)
    let s:flash.winid = 0
    let s:flash.id = 0
    let s:flash.state = 0
  endif
endfunction "}}}

function! s:toggle_flash(timer_id) "{{{

  if s:flash.state
    call s:flash_off(0)
  else
    call s:flash_on(0)
  endif

endfunction "}}}

function! s:stop_toggle_timer(timer_id) "{{{
  if exists('s:flash') && s:flash.toggle_timer > 0
    call timer_stop(s:flash.toggle_timer)
  endif
endfunction "}}}

function! s:get_user_config() "{{{
  let duration = get(g:, 'nflasher_duration', 100)
  let repeat = get(g:, 'nflasher_repeat', 3)
  let keep = get(g:, 'nflasher_keep_flash', 0)
  let highlight = get(g:, 'nflasher_highlight', 'IncSearch')

  return { 'duration': duration, 'repeat': repeat * 2 - 1, 'keep_flash': keep, 'highlight': highlight }
endfunction "}}}

function! s:flash() abort " {{{
  let s:user_config = s:get_user_config()

  if !exists('s:flash')
    let s:flash = s:init_flash()
  endif

  if s:flash.toggle_timer > 0
    call s:stop_toggle_timer(0)
    call s:flash_off(0)
  endif

  " delete the previous flash
  if s:user_config.keep_flash && s:flash.id > 0
    call s:flash_off(0)
  endif

  call s:flash_on(0)

  if !s:user_config.keep_flash
    let s:toggle_timer = timer_start(
          \s:user_config.duration, 
          \function('<SID>toggle_flash'), 
          \{'repeat': s:user_config.repeat})

    let s:flash.toggle_timer = s:toggle_timer
  endif

endfunction "}}}

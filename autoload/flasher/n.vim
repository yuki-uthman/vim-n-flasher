function! flasher#n#flash()
  call s:flash()
endfunction

" for autocmd
function! flasher#n#flash_off(mode) 
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

function! s:get_visual_selection() "{{{
  let [l:lnum1, l:col1] = getpos("'<")[1:2]
  let [l:lnum2, l:col2] = getpos("'>")[1:2]
  if &selection !=# 'inclusive'
    let l:col2 -= 1
  endif
  let l:lines = getline(l:lnum1, l:lnum2)
  if !empty(l:lines)
    let l:lines[-1] = l:lines[-1][: l:col2 - 1]
    let l:lines[0] = l:lines[0][l:col1 - 1 : ]
  endif
  return join(l:lines, "\n")
endfunction "}}}

function! s:init_flash() "{{{

  return { 
        \'winid': 0,
        \'id': 0,
        \'state': 0,
        \'toggle_timer': 0 }

endfunction "}}}

function! s:flash_on(timer_id) "{{{

  let save_cursor = getcurpos()
  normal! gn
  exec "normal! \<ESC>"
  call setpos('.', save_cursor)

  let string =  s:get_visual_selection()
  let string = escape(string, '~')

  let winid = win_getid()
  let id = matchadd(s:user_config.highlight, '\%#' . string) 

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
  let duration = get(g:, 'n_flasher_duration', 100)
  let repeat = get(g:, 'n_flasher_repeat', 3)
  let keep = get(g:, 'n_flasher_keep_flash', 0)
  let highlight = get(g:, 'n_flasher_highlight', 'IncSearch')

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


augroup nflasher
    au!
    au CursorMoved * call nflasher#flash_off('n')
    au InsertEnter * call nflasher#flash_off('i')
augroup end


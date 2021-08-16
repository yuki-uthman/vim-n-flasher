
augroup n_flasher
    au!
    au CursorMoved * call flasher#n#flash_off('n')
    au InsertEnter * call flasher#n#flash_off('i')
augroup end


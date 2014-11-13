"Check to see if the filetype was automagically identified by Vim

if exists("did_load_filetypes")
    finish
else
    augroup filetypedetect
    "au! BufRead,BufNewFile *.m, *.h      setfiletype objc
    au! BufRead,BufNewFile *.m, *.h      set ft=objc
    augroup END
endif

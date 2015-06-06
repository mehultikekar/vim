if did_filetype()
    finish
endif

if getline(1) =~# '^#!.*/bin/env\s\+node\>' || getline(2) =~ 'node'
    setfiletype javascript
endif

command! -nargs=* IJulia :call SuperTabSetDefaultCompletionType('<c-x><c-u>') | :py km_from_string("<args> --profile julia")

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentkeys=!^F,o,O,},),=end
setlocal indentexpr=bsv#Indent()
" for preserving alignment with spaces
setlocal preserveindent
setlocal copyindent

let s:openExpr = '\v(<begin>|<action>|<actionvalue>|<case>|<seq>|<par>|<rules>|\{|\()\zs'
let s:closeExpr = '\v(<end>|<endaction>|<endactionvalue>|<endcase>|<endseq>|<endpar>|<endrules>|\}|\))\zs'

function! s:TokenPositions(line, token_re)
    " list of column numbers of tokens in line
    let toksplits = split(a:line, a:token_re, 1)
    unlet toksplits[-1]
    let olist = []
    let sum = 0
    for val in toksplits
        let sum += strlen(val)
        call add(olist, sum)
    endfor
    return olist
endfunction

function! s:TokenList(line)
    " Convert line to a list of 0s and 1s. 0 = open expr, 1 = close expr
    let open_pos = s:TokenPositions(a:line, s:openExpr)
    let close_pos = s:TokenPositions(a:line, s:closeExpr)
    let toks = []
    while len(open_pos) > 0 && len(close_pos) > 0
       if open_pos[0] < close_pos[0]
            call add(toks, 0)
            unlet open_pos[0]
        else
            call add(toks, 1)
            unlet close_pos[0]
        endif
    endwhile
    call extend(toks, map(open_pos, '0'))
    call extend(toks, map(close_pos, '1'))
    return toks
endfunction

function! s:NumPrevClosed(line)
    " how many exprs from previous lines closed in current line
    let tok = s:TokenList(a:line)
    let nopened = 0
    let nprevclosed = 0
    for val in tok
        if val ==# 0
            let nopened += 1
        else
            if nopened ==# 0
                let nprevclosed += 1
            else
                let nopened -= 1
            endif
        endif
    endfor

    return nprevclosed
endfunction

function! s:NumNewOpened(line)
    " how many new exprs opened in current line
    let tok = s:TokenList(a:line)
    let nclosed = 0
    let nnewopened = 0
    for val in reverse(tok)
        if val ==# 1
            let nclosed += 1
        else
            if nclosed ==# 0
                let nnewopened += 1
            else
                let nclosed -= 1
            endif
        endif
    endfor

    return nnewopened
endfunction

function! s:IsComment(lnum, line)
    return synIDattr(synID(a:lnum, match(a:line, '\v\S') + 1, 0), "name") ==# "bsvComment"
endfunction

function! s:PrevNonComment(lnum)
    let lnum = prevnonblank(a:lnum)
    let line = getline(lnum)
    while lnum != 0 && s:IsComment(lnum, line)
        let lnum = prevnonblank(lnum - 1)
        let line = getline(lnum)
    endwhile
    return [lnum, line]
endfunction

function! s:InModule(lnum)
    " is line in module scope
    let lnum = a:lnum
    let line = getline(lnum)
    while lnum != 0
        if line =~# '\v^\s*module>[^\=]*$'
            return 1
        elseif line =~# '\v^\s*endmodule>'
            return 0
        endif
        let [lnum, line] = s:PrevNonComment(lnum - 1)
    endwhile
    return 0
endfunction

function! bsv#Indent()
    let [prevlnum, prevline] = s:PrevNonComment(v:lnum - 1)
    if prevlnum ==# 0
        return 0
    endif

    let line = getline(v:lnum)
    if s:IsComment(v:lnum, line)
        return indent(v:lnum)
    endif

    let ind = s:NumNewOpened(prevline)
    if ind ==# 0 | let ind += (prevline =~# '\v^\s*(rule|typeclass|instance)>') | endif
    if ind ==# 0 | let ind += (prevline =~# '\v^\s*(function|module)>((\s\=\s)@!.)*$') | endif
    if ind ==# 0 | let ind += (prevline =~# '\v^\s*method>((\s\=\s)@!.)*$') && s:InModule(prevlnum) | endif
    " interface used as an expression: a = interface Put ... endinterface
    if ind ==# 0 | let ind += (prevline =~# '\v\=\s*interface>') | endif
    if ind ==# 0
        " indent all interfaces and in modules and top-level
        " indent subinterfaces in modules but not in top-level
        if prevline =~# '\v^\s*interface>((\s\=\s)@!.)*$'
            if indent(prevlnum) == 0 || s:InModule(prevlnum)
                let ind += 1
            endif
        endif
    endif
    if ind ==# 0
        " indent if/for/else followed by single statements
        " doesn't handle multiple levels like:
        " for ()
        "   if ()
        "     ()  // this will not be indented correctly
        if prevline =~#'\v^\s*(if|else|for|while)>' && prevline !~# '\v\;\s*$'
            let ind += 1
        endif
    endif

    let ded = s:NumPrevClosed(line)

    if ded ==# 0
        let ded += (line =~# '\v^\s*(endrule|endtypeclass|endinstance|endfunction|endmodule|endinterface|endmethod)>')
    endif
    " to dedent if/for/else followed by single statements,
    " need to check line before previous
    let [pprevlnum, pprevline] = s:PrevNonComment(prevlnum - 1)
    if pprevlnum != 0 && pprevline =~#'\v^\s*(if|else|for|while)>' && pprevline !~# '\v\;\s*$' && s:NumNewOpened(pprevline) == 0
        let ded += 1
    endif

    return indent(prevlnum) + (ind - ded) * &shiftwidth
endfunction

" Selectively disable tagbar versions
if v:version == 700 && !has('patch167')
    let g:pathogen_disabled = ['tagbar']
else
    let g:pathogen_disabled = ['tagbar-old']
endif
" Load all plugins
call pathogen#infect()

set guifont=Inconsolata\ 12
" Solarized options
if $TERM == "screen"
    set term=xterm-256color
endif
if has('gui_running') || ($TERM == "xterm-256color") || ($TERM == "screen")
    let g:solarized_termtrans=1
    set background=dark
    colorscheme solarized
endif

" Fix for SuperTab messing up abbrevs with <CR>
let g:SuperTabCrMapping = 0
let g:SuperTabDefaultCompletionType = 'context'

let mapleader = "-"

set expandtab
set tabstop=4
set autoindent
set shiftwidth=4

" Fold based on indent
set foldmethod=indent
" Fold nothing by default
set foldlevel=99
" Folded part will show nothing except: n lines folded
set foldtext=
" Fold comments as well. Default foldignore is # which wont fold py comments and C preprocs
set foldignore=
nnoremap <space> za

" Soft wrap at word boundaries
set linebreak
set incsearch
set hlsearch

" Up down by displayed lines rather than actual lines
nnoremap <up> gk
nnoremap <down> gj
inoremap <up> <C-o>gk
inoremap <down> <C-o>gj

" Enabled file type detection
" Enabled file language-dependent indenting
filetype plugin on
filetype indent on

autocmd FileType pandoc iabbrev times ×

" Add margin on left and set its color to simulate left margin in tex
autocmd FileType tex set foldcolumn=3
autocmd FileType tex highlight! link FoldColumn Normal

command TrailingWhitespace let cpos = getpos('.') | %s/\s\+$//ge | call setpos('.', cpos) |
command ChangeDirectory cd %:p:h
command W w
command Q q
command WQ wq
command LogClean g/\(SNPS\|clk_gate\)/d

" Clear line and go to next
nnoremap <leader>dd 0Dj

" Ignore semicolons in bsv
let g:bsv_ignore_semicolon = 1
autocmd FileType bsv setlocal dict+=~/.vim/bundle/bsv/bsv.words
autocmd FileType bsv call SuperTabSetDefaultCompletionType('<c-x><c-k>')

autocmd BufNewFile,BufRead let b:verilog_indent_modules = 1

" Change diff colors
highlight! link DiffText MatchParen

"func Eatchar(pat)
"    let c = nr2char(getchar(0))
"    return (c =~ a:pat) ? '' : c
"endfunc
"iabbr <silent> lm λ<C-R>=Eatchar('\s')<CR>
"iabbr <silent> xx ×<C-R>=Eatchar('\s')<CR>

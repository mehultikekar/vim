" Load all plugins
call pathogen#infect()

"set guifont=DejaVu\ Sans\ Mono\ 10
set guifont=Inconsolata\ 11
" Solarized options
let g:solarized_termtrans=1
set background=dark
colorscheme solarized

let g:pandoc_no_empty_implicits = 1
let g:pandoc_no_spans = 1
let g:pandoc_no_folding = 1

let g:vimroom_ctermbackground="8"
let g:vimroom_guibackground="#002b36"
let g:vimroom_width=100

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

"autocmd FileType pandoc iabbrev times ×

" Add margin on left and set its color to simulate left margin in tex
"autocmd FileType tex set foldcolumn=3
"autocmd FileType tex highlight! link FoldColumn Normal

command TrailingWhitespace let cpos = getpos('.') | %s/\s\+$//ge | call setpos('.', cpos) |
command ChangeDirectory cd %:p:h
command W w
command Q q
command WQ wq
command LogClean g/\(SNPS\|clk_gate\)/d

" Clear line and go to next
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>dd 0Dj
nnoremap <silent> m :nohlsearch<cr>

" Ignore semicolons in bsv
let g:bsv_ignore_semicolon = 1
autocmd FileType bsv setlocal dict+=~/.vim/bundle/bsv/bsv.words
autocmd FileType bsv call SuperTabSetDefaultCompletionType('<c-x><c-k>')

autocmd FileType cpp nnoremap <silent> <buffer> <cr> :CSearchContext<cr>
autocmd FileType cpp call SuperTabSetDefaultCompletionType('<c-x><c-u>')

autocmd BufNewFile,BufRead let b:verilog_indent_modules = 1

" Change diff colors
highlight! link DiffText MatchParen

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
set laststatus=2

if has('gui_running')
    autocmd BufEnter * sign define dummy
    autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
    set ballooneval
endif

command Conceal set conceallevel=1
command Reveal set conceallevel=0

au BufNewFile,BufRead *.lib set filetype=dummy

set shell=/bin/tcsh

set directory^=~/.vim/swaps
set backupdir^=~/.vim/backups
command Link :normal i [<a href="http://ieeexplore.ieee.org/xpl/articleDetails.jsp?tp=&arnumber=">link</a>]

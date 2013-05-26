if v:version == 700 && !has('patch167')
    let g:pathogen_disabled = ['tagbar']
else
    let g:pathogen_disabled = ['tagbar_old']
endif
call pathogen#infect()

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
" Add margin on left and set its color
set foldcolumn=3
highlight! link FoldColumn Normal

 " Up down by displayed lines rather than actual lines
nnoremap <up> gk
nnoremap <down> gj
inoremap <up> <C-o>gk
inoremap <down> <C-o>gj

if has("autocmd")
  " Enabled file type detection
  " Enabled file language-dependent indenting
  filetype plugin on
  filetype indent on
endif " has ("autocmd")

source $VIMRUNTIME/macros/matchit.vim

command RemoveTrailingWhitespace %s/\s\+$//ge
command ChangeDirectory cd %:p:h
command W w
command Q q
command WQ wq

" Clear line and go to next
nnoremap <leader>dd 0Dj

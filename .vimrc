syntax on
set autoindent
set smartindent
set incsearch
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set ignorecase
set hlsearch
set autoread
set splitright

map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

map 0 ^

nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

set wrap
set number

set scrolloff=1

"Function for relative line numbers"
function! NumberToggle()
        if(&relativenumber == 1)
                set number
        else
                set relativenumber
        endif
endfunction

nnoremap <C-n> :call NumberToggle()<cr>


set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

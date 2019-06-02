"
" ＿人人人人人＿
" ＞  vimrc   ＜
" ￣ＹＹＹＹＹ
"

set encoding=utf-8
set fileencodings=utf8
let mapleader = "\<Space>"

"--------
" Search
"--------

set ignorecase
set smartcase
set wildignorecase
set wildmode=list,full

"------
" Edit
"------
set tabstop=4

" language specific tab and space settings
au BufNewFile,BufRead *.sh   set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufNewFile,BufRead *.html set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufNewFile,BufRead *.py   set nowrap tabstop=4 shiftwidth=4 autoindent expandtab
au BufNewFile,BufRead *.c    set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.cpp  set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.cs   set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.h    set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.hpp  set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.js   set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufNewFile,BufRead *.ts   set nowrap tabstop=4 shiftwidth=4 autoindent expandtab
au BufRead,BufNewFile *.ts   set filetype=typescript
au BufNewFile,BufRead *.vue  set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufRead,BufNewFile *.rs   set nowrap tabstop=4 shiftwidth=4
au BufRead,BufNewFile *.rs   set filetype=rust
au BufNewFile,BufRead *.yml  set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufNewFile,BufRead *.pp   set nowrap tabstop=4 shiftwidth=4 autoindent expandtab

set noexpandtab
set autoindent
set backspace=indent,eol,start
set wrapscan
set showmatch
set wildmenu
set formatoptions+=mM

"---------
" Display
"---------

set number
set ruler
set nolist
set nowrap
set laststatus=2
set cmdheight=2
set showcmd
set title

syntax on

"-----------
" Highlight
"-----------

highlight Comment cterm=bold
highlight Constant cterm=bold
highlight Identifier cterm=bold
highlight Statement cterm=bold
highlight PreProc cterm=bold
highlight Type cterm=bold
highlight Special cterm=bold

"-------
" files
"-------

" file backups and undo files
set backupdir=$HOME/.vimtmp
set directory=$HOME/.vimtmp
set undodir=$HOME/.vimtmp

" swap files
set noswapfile

"---------------------
" tab window settings
"---------------------

nnoremap <S-Tab> gt
nnoremap <Tab><Tab> gT
for i in range(1, 9)
    execute 'nnoremap <Tab>' . i . ' ' . i . 'gt'
endfor
nnoremap <C-Insert> :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>

" split window
set splitright

" git diff like highlighting of extra whitespaces
let c_space_errors=1
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

" Delete without cutting
" https://stackoverflow.com/a/11993928/2431453
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" to make vimdiff look prettier
" This settings should be after the colorscheme to avoid it being overriden.
hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7

" enable editing in vimdiff
set noro

"--------
" Python
"--------
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"-------
" CMake
"-------
au BufNewFile,BufRead CMakeLists.txt set filetype=cmake
au BufNewFile,BufRead *.cmake set filetype=cmake

"---------
" Plugins
"---------
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
" Plug 'scrooloose/syntastic'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'vim-python/python-syntax'
Plug 'rust-lang/rust.vim'

" Language server protocol
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

call plug#end()


"-----------------
" Plugin settings
"-----------------

" Language server protocol

let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

if executable('pyls')
  " pip install python-language-server
  au User lsp_setup call lsp#register_server({
      \ 'name': 'pyls',
      \ 'cmd': {server_info->['pyls']},
      \ 'whitelist': ['python'],
      \ })
endif

if executable('rls')
  au User lsp_setup call lsp#register_server({
      \ 'name': 'rls',
      \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
      \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
      \ 'whitelist': ['rust'],
      \ })
endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" python-syntax
let python_highlight_all = 1

" rust-vim
let g:rustfmt_autosave = 1

" syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_mode_map = {
"        \ "mode": "active",
"        \ "active_filetypes": ["python", "rust", "typescript", "cpp"],
"        \ "passive_filetypes": ["sh"] }
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_python_checkers=['flake8', 'mypy']

" NERDTree
nnoremap <silent><C-e> :NERDTreeTabsToggle<CR>

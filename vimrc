"
" ＿人人人人人＿
" ＞  vimrc   ＜
" ￣ＹＹＹＹＹ
"


set encoding=utf-8
set fileencodings=utf8
let mapleader = "\<Space>"

if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" Search
"
set ignorecase
set smartcase
set wildignorecase
set wildmode=list,full

"---------------------------------------------------------------------------
" 編集に関する設定:
"
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

"---------------------------------------------------------------------------
" Display
"
set number
set ruler
set nolist
set nowrap
set laststatus=2
set cmdheight=2
set showcmd
set title

"---------------------------------------------------------------------------
" Tabline
"
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " Always display tabline

"---------------------------------------------------------------------------
" Highlight
"
highlight Comment cterm=bold
highlight Constant cterm=bold
highlight Identifier cterm=bold
highlight Statement cterm=bold
highlight PreProc cterm=bold
highlight Type cterm=bold
highlight Special cterm=bold

"---------------------------------------------------------------------------
" files
"
" file backups and undo files
if has('win32')
  set backupdir=$HOME/vimtmp
  set directory=$HOME/vimtmp
  set undodir=$HOME/vimtmp

else
  set backupdir=$HOME/.vimtmp
  set directory=$HOME/.vimtmp
  set undodir=$HOME/.vimtmp
endif

" swap files
set noswapfile

"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let uname = system('uname')
  if uname =~? "linux"
    set term=builtin_linux
  elseif uname =~? "freebsd"
    set term=builtin_cons25
  elseif uname =~? "Darwin"
    set term=builtin_xterm
    "set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

" WindowsがSJISでvimrcを読み込むための設定
highlight zenkakuda cterm=underline ctermfg=black guibg=black
if has('win32') && !has('gui_running')
	" win32のコンソールvimはsjisで設定ファイルを読むので、
	" sjisの全角スペースの文字コードを指定してやる
	match zenkakuda /\%u8140/
else
	match zenkakuda /　/ "←全角スペース
endif

" OS毎に.vimの読み込み先を変える
if has('win32')
	:let $VIMFILE_DIR = 'vimfiles'
else
	:let $VIMFILE_DIR = '.vim'
endif

"---------------------------------------------------------------------------
" tab window settings
nnoremap <S-Tab> gt
nnoremap <Tab><Tab> gT
for i in range(1, 9)
    execute 'nnoremap <Tab>' . i . ' ' . i . 'gt'
endfor
nnoremap <C-Insert> :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>

"---------------------------------------------------------------------------
" split window settings
set splitright

"---------------------------------------------------------------------------
" git diff like highlighting of extra whitespaces
let c_space_errors=1
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

"---------------------------------------------------------------------------
" Delete without cutting
" https://stackoverflow.com/a/11993928/2431453
nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

"---------------------------------------------------------------------------
" Python
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"---------------------------------------------------------------------------
" CMake
au BufNewFile,BufRead CMakeLists.txt set filetype=cmake
au BufNewFile,BufRead *.cmake set filetype=cmake

"
"---------------------------------------------------------------------------
" Plugins
"

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'wincent/command-t'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'godlygeek/tabular'
"Plugin 'plasticboy/vim-markdown'
Plugin 'quickrun.vim'
Plugin 'mrtazz/simplenote.vim'
"Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimshell.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'szw/vim-tags'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'AnsiEsc.vim'
Plugin 'soramugi/auto-ctags.vim'
Plugin 'hdima/python-syntax'
Plugin 'rust-lang/rust.vim'
Plugin 'rhysd/vim-clang-format'
Plugin 'nvie/vim-flake8'
Plugin 'leafgarland/typescript-vim'
Plugin 'tell-k/vim-autopep8'
Plugin 'tpope/vim-fireplace'
Plugin 'Glench/Vim-Jinja2-Syntax'
Plugin 'yukinarit/vim-one'
Plugin 'cespare/vim-toml'

call vundle#end()
filetype plugin indent on


"
"---------------------------------------------------------------------------
" Plugin specific settings
"

" unite
"let g:unite_enable_start_insert=1
"noremap <C-P> :Unite buffer<CR>
"noremap <C-N> :Unite -buffer-name=file file<CR>
"" List of recently opened files
"noremap <C-Z> :Unite file_mru<CR>

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = {
        \ "mode": "active",
        \ "active_filetypes": ["python", "rust", "typescript", "cpp"],
        \ "passive_filetypes": ["sh"] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['flake8', 'mypy']
"let g:loaded_syntastic_python_pylint_checker = 0

" simplenote
let g:SimplenoteUsername = $SIMPLENOTEUSERNAME
let g:SimplenotePassword = $SIMPLENOTEPASSWORD

"
" YouCompleteMe
"

" for C++
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_server_use_vim_stdout = 1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0

let g:ycm_always_populate_location_list = 1
let g:ycm_open_loclist_on_ycm_diags = 1

" Override ctags keymap with YCM based commands
map <C-]> :YcmComplete GoTo<CR>
map <C-T> <C-O>
" Opening tags in new tab
map <C-\> :tab split<CR>:YcmComplete GoTo<CR>

" for Python
let g:ycm_path_to_python_interpreter = $HOME . '/.pyenv/shims/python3'
let g:ycm_python_binary_path = 'python3'

" for Rust
let g:ycm_rust_src_path = $HOME . '/repos/rust/src'
let g:rustfmt_autosave = 1

" fswitch
" Switch to the file and load it into the current window
nnoremap <silent> <Leader>s :FSHere<CR>
" Switch to the file and load it into the window on the right
nnoremap <silent> <Leader>sr :FSRight<CR>
" Switch to the file and load it into a new window split on the right
nnoremap <silent> <Leader>sR :FSSplitRight<SR>

let g:fsnonewfiles = 'on'
augroup myfswitch
  au!
  au BufEnter *.h let b:fswitchdst    = 'cpp,cc,c'
  au BufEnter *.h let b:fswitchlocs   = 'src,../src,reg:/include/src/,reg:/include.*/src/'
  au BufEnter *.cpp let b:fswitchdst  = 'h,hpp'
  au BufEnter *.cpp let b:fswitchlocs = 'include,../include,./,reg:/src/include/,reg:/src.*/include/,reg:|src|include/**|'
augroup END

" vim-tags
let g:vim_tags_use_language_field = 1
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" NERDTree
nnoremap <silent><C-e> :NERDTreeTabsToggle<CR>

" python-syntax
let python_highlight_all = 1

" vim-clang-format
autocmd FileType c,cpp ClangFormatAutoEnable
let g:clang_format#detect_style_file = 1

" vim-autopep8
let g:autopep8_disable_show_diff = 1
let g:autopep8_aggressive = 2

" vim-one
colorscheme one
let g:one_allow_italics = 1
set background=dark

"---------------------------------------------------------------------------
" to make vimdiff look prettier
" This settings should be after the colorscheme to avoid it being overriden.
hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7
"highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
"highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
"highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
"highlight DiffText   cterm=bold ctermfg=10 ctermbg=21

" enable editing in vimdiff
set noro

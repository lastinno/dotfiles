"
" ＿人人人人人＿
" ＞  vimrc   ＜
" ￣ＹＹＹＹＹ
"


"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
if has('win32')
  for path in split(glob($VIM.'/plugins/*'), '\n')
    if isdirectory(path) | let &runtimepath = &runtimepath.','.path | end
  endfor
endif

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
if has('win32')
  source $VIM/plugins/kaoriya/encode_japan.vim
  set langmenu=english
endif
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
" if has('mac')
"   set langmenu=japanese
" endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif

"set encoding=utf-8
set fileencodings=utf8,iso-2022-jp,euc-jp,cp932,sjis

" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" Leader
let mapleader = "\<Space>"

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" case insensitive file name completion
set wildignorecase
set wildmode=list,full

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=4

" language specific tab and space settings
au BufNewFile,BufRead *.html set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufNewFile,BufRead *.py   set nowrap tabstop=4 shiftwidth=4 autoindent expandtab
au BufNewFile,BufRead *.c    set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.cpp  set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.cs   set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.h    set nowrap tabstop=4 shiftwidth=4
au BufNewFile,BufRead *.js   set nowrap tabstop=2 shiftwidth=2 autoindent expandtab
au BufNewFile,BufRead *.ts   set nowrap tabstop=2 shiftwidth=2 autoindent expandtab

" タブをスペースに展開しない (expandtab:展開する)
set noexpandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set nowrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
colorscheme desert " (Windows用gvim使用時はgvimrcを編集すること)
" 90文字目にラインを入れる
"set colorcolumn=90
"

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
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if has('win32')
  if kaoriya#switch#enabled('disable-vimdoc-ja')
    let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "vimdoc-ja"'), ',')
  endif
endif

" Copyright (C) 2011 KaoriYa/MURAOKA Taro


"---------------------------------------------------------------------------
" to make vimdiff look prettier
hi DiffAdd    ctermfg=black ctermbg=2
hi DiffChange ctermfg=black ctermbg=3
hi DiffDelete ctermfg=black ctermbg=6
hi DiffText   ctermfg=black ctermbg=7

" enable editing in vimdiff
set noro

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
" Highlight 80 column line
if exists('+colorcolumn')
	set colorcolumn=80
else
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

"---------------------------------------------------------------------------
" Python
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"---------------------------------------------------------------------------
" CMake
au BufNewFile,BufRead CMakeLists.txt set filetype=cmake


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
Plugin 'wincent/command-t'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'quickrun.vim'
Plugin 'mrtazz/simplenote.vim'
Plugin 'Shougo/unite.vim'
Plugin 'Shougo/vimshell.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
if has('unix')
  Plugin 'Valloric/YouCompleteMe'
endif
"Plugin 'itchyny/lightline.vim'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/syntastic'
Plugin 'szw/vim-tags'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'AnsiEsc.vim'
Plugin 'soramugi/auto-ctags.vim'
Plugin 'hdima/python-syntax'

call vundle#end()
filetype plugin indent on


"
"---------------------------------------------------------------------------
" Plugin specific settings
"

" unite
let g:unite_enable_start_insert=1
noremap <C-P> :Unite buffer<CR>
noremap <C-N> :Unite -buffer-name=file file<CR>
" List of recently opened files
noremap <C-Z> :Unite file_mru<CR>

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = {
        \ "mode": "passive",
        \ "active_filetypes": [],
        \ "passive_filetypes": [] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_checkers = ['']
let g:syntastic_python_pylint_args = "--disable=C0111" "let g:syntastic_python_pylint_args = "--disable=C0001"
" simplenote
let g:SimplenoteUsername = $SIMPLENOTEUSERNAME
let g:SimplenotePassword = $SIMPLENOTEPASSWORD

"
" YouCompleteMe
"
if has('unix')
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

  " for python
  let g:ycm_path_to_python_interpreter = $HOME . '/.pyenv/shims/python'
  let g:ycm_python_binary_path = 'python'

endif

" fswitch
" Switch to the file and load it into the current window
nnoremap <silent> <Leader>s :FSHere<CR>
" Switch to the file and load it into the window on the right
nnoremap <silent> <Leader>sr :FSRight<CR>
" Switch to the file and load it into a new window split on the right
nnoremap <silent> <Leader>sR :FSSplitRight<SR>

" vim-tags
let g:vim_tags_use_language_field = 1
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" NERDTree
nnoremap <silent><C-e> :NERDTreeTabsToggle<CR>

" python-syntax
let python_highlight_all = 1

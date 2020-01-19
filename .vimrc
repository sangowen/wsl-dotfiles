set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
" set rtp+=~/.vim/bundle/altercation/vim-colors-solarized/colors/solarized.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" put NERDTree higher or part of the plugin will not be loaded correctly
" Plugin 'scrooloose/nerdtree'
" Plugin 'francoiscabrol/ranger.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'fisadev/vim-ctrlp-cmdpalette'
Plugin 'tpope/vim-surround'
" Plugin 'charz/multi-cscope-db'
" Plugin 'taglist.vim'
" Plugin 'ctags.vim'
" Plugin 'easymotion'
Plugin 'chrisbra/vim-diff-enhanced'
Plugin 'morhetz/gruvbox'
Plugin 'tpope/vim-commentary'
Plugin 'lilydjwg/colorizer'
Plugin 'guns/xterm-color-table.vim'
Plugin 'gcmt/taboo.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-rooter'

" golang
Plugin 'fatih/vim-go'
" Plugin 'SirVer/ultisnips'

Plugin 'auto-pairs'

" Markdown
Plugin 'suan/vim-instant-markdown'
" Plugin 'shime/vim-livedown'
Plugin 'plasticboy/vim-markdown'
Plugin 'nelstrom/vim-markdown-folding'
Plugin 'vimwiki/vimwiki'
Plugin 'mattn/calendar-vim'
" Plugin 'vim-pandoc/vim-pandoc'
" Plugin 'gabrielelana/vim-markdown'
" Plugin 'vim-pandoc/vim-pandoc-syntax'

" Plugin 'chrisbra/csv.vim'

Plugin 'vim-airline/vim-airline'

Plugin 'AutoComplPop' " conflicts with YouCompleteMe
" Plugin 'Valloric/YouCompleteMe' " file-completion of hidden files are broken

call vundle#end()
" The following are examples of different formats supported.
" Keep Plugin commands between here and filetype plugin indent on.
" scripts on GitHub repos
" Plugin 'tpope/vim-fugitive'
" Plugin 'Lokaltog/vim-easymotion'
" Plugin 'tpope/vim-rails.git'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" scripts from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Plugin 'FuzzyFinder'
" scripts not on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" ...

filetype plugin indent on     " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Plugin commands are not allowed.
" Put your stuff after this line
"---v1.4版---

set fileencodings=utf-8,big5,euc-jp,gbk,euc-kr,utf-bom,iso8859-1
set hls
set incsearch 
set history=100
set wrap
set mouse=nv

" make vim open at last editted
au BufReadPost * if line("'\"") > 0|if line("'\"")
\ <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

set listchars=tab:>-,trail:-
syntax on
filetype on
set wildmenu

"-------------------
"Wayne
"-------------------
" Basic Settings
set nu
"set cursorline
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap z<space> :ZRangerVSplit<space>
set wildignorecase
set wildmode=longest:full
set splitright
set splitbelow
let mapleader = ","

if $RANGER_LEVEL == 1
  nnoremap qq :qa<cr>
  nnoremap qa :qa<cr>
  nnoremap qt :tabc<cr>
  nnoremap tq :tabc<cr>
endif
vmap <cr> "+y

" nnoremap <leader>v :ZRangerVSplit<cr>
" nnoremap <leader>s :ZRangerSplit<cr>
" nnoremap <leader>v :RangerWorkingDirectoryVSplit<CR>
" nnoremap <leader>s :RangerWorkingDirectorySplit<CR>
nmap \ ,
" nmap <Space> ,
" set fdm=syntax


command! -nargs=* ToRanger :silent call ToRanger(<f-args>)
function! ToRanger(...)
  execute ":terminal ++hidden vi_to_ranger"
endfunction

nnoremap <c-g> :terminal ++hidden vi_to_ranger<cr>


"-------------------
"Go
"-------------------
autocmd FileType go nmap <leader>r  <Plug>(go-run)
" autocmd FileType go nmap <leader>b  <Plug>(go-build)
" autocmd FileType go nmap <leader>t  <Plug>(go-test)
" run :GoBuild or :GoTestCompile based on the go file
autocmd FileType go nmap gs <Plug>(go-def-split)
autocmd FileType go nmap gS <Plug>(go-def-vertical)
" autocmd FileType go nmap gr <Plug>(go-referrers)
" autocmd FileType go nnoremap gr :lgetexpr system("grep -Inr ".expand("<cword>")) \| lw<CR>
autocmd FileType go nnoremap gr :call Waynetest()<CR>
nnoremap gr :call Waynetest()<CR>
nnoremap gl :lcl<CR>

function Waynetest()
  let l:current_word = expand("<cword>")
  :lgetexpr system("grep -Inr ".l:current_word) | lw
  :execute '/'.l:current_word
endfunction

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
let g:go_fmt_command = "goimports"
set autowrite
let g:go_test_timeout = '10s'
" let g:go_highlight_array_whitespace_error = 1
" let g:go_highlight_trailing_whitespace_error = 1
let g:go_auto_sameids = 1
let g:go_highlight_operators = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']

let g:go_auto_type_info = 1
let g:go_updatetime=1000
" let g:go_info_mode = 'guru'


let g:syntastic_go_checkers = ['golint', 'govet']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:syntastic_go_checkers = ['golint', 'govet', 'gometalinter']
let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')


"Let vim Recongnize alt key
"	tmux.conf: set -sg escape-time 0
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "nmap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set ttimeout ttimeoutlen=10
"nnoremap <M-p> :CtrlPCmdPalette<cr>
"nnoremap <M-n> :NERDTreeToggle<cr>
"nnoremap <space>n :NERDTreeToggle<cr>
"nnoremap <M-m> :InstantMarkdownPreview<cr>
" nnoremap <space>t "=strftime("%Y/%m/%d/%H.%M.%S")<CR>P
nnoremap <space>t :TabooRename 
nnoremap <space>T "=strftime("%Y%m%d_%H%M%S")<CR>P
"nnoremap <space>w :cd %:h<CR> :NERDTree<CR>
inoremap jj <ESC>
" Don't iremap <C-m><C-i><C-h>, they will be recognized as enter, tab and backspace

"Color configuration
hi LineNr cterm=bold ctermfg=DarkGrey ctermbg=NONE
hi CursorLineNr cterm=bold ctermfg=Green ctermbg=NONE
set background=dark
set t_Co=256
" let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italic=1
colorscheme gruvbox
set cursorline
set csre
"set autochdir

"""Markdown setup
"	disable markdown folding from playstic boy
let g:vim_markdown_folding_disabled=1
"	make text concealed if it matches markdown syntax
set conceallevel=2
"	set indent rule and wrap if file extension is .md or .markdown
au BufNewFile,BufFilePre,BufRead *.md,*.markdown set filetype=markdown | set wrap | set foldlevel=5
" livedown
let g:livedown_autorun = 0

set tabpagemax=20
let g:instant_markdown_autostart = 0
" vimwiki
let g:vimwiki_list = [{'path': '~/my_site/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_folding = 'expr'
let g:vimwiki_table_mappings = 0
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_list_ignore_newline = 0

autocmd FileType md autocmd BufWritePre <buffer> %s/\s\+$//e
" autocmd VimResized * redraw!

let g:ycm_filetype_blacklist = {
  \ 'tagbar' : 1,
  \ 'qf' : 1,
  \ 'notes' : 1,
  \ 'markdown' : 1,
  \ 'unite' : 1,
  \ 'text' : 1,
  \ 'pandoc' : 1,
  \ 'infolog' : 1,
  \ 'mail' : 1
  \}

" matt Calendar plugin for vimwiki
function! ToggleCalendar()
  execute ":Calendar"
  if exists("g:calendar_open")
    if g:calendar_open == 1
      execute "q"
      unlet g:calendar_open
    else
      g:calendar_open = 1
    end
  else
    let g:calendar_open = 1
  end
endfunction
nnoremap <leader>wc :call ToggleCalendar() <cr>

let g:calendar_monday = 1
" let g:vimwiki_use_calendar = 0

" itchyny calendar
let g:calendar_google_calendar = 1

"""NERDTree setup
""	seems to be fine to go without these defaut settings
"let g:NERDTreeMouseMode = 3
""let g:NERDTreeDirArrows = 1
""let g:NERDTreeDirArrowExpandable = '▸'
""let g:NERDTreeDirArrowCollapsible = '▾'
""let g:NERDTreeGlyphReadOnly = "RO"
""	NERDTree when enter vim
"autocmd VimEnter * NERDTree | wincmd p
""	share NERDTreeBuffer in tabs
"autocmd BufWinEnter * NERDTreeMirror | wincmd p
""	close window if NERDTree is the last and only buffer existing
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

"CtrlP setup
"	cache to have instant search result
let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_map = '<A-p>'
let g:ctrlp_map = '<c-p>'
"let g:ctrlp_cmdpalette_execute=1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'node_modules':  'node_modules$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:25'


" fasd integration
" https://github.com/clvv/fasd/wiki/Vim-Integration
" Z - cd to recent / frequent directories
command! -nargs=* Z :call Z(<f-args>)
function! Z(...)
  let cmd = 'fasd -d -e printf'
  for arg in a:000
    let cmd = cmd . ' ' . arg
  endfor
  let path = system(cmd)
  if isdirectory(path)
    echo path
    exec 'cd' fnameescape(path)
  endif
endfunction

command! -nargs=* Znetrw :call Znetrw(<f-args>)
function! Znetrw(...)
  let cmd = 'fasd -d -e printf'
  for arg in a:000
    let cmd = cmd . ' ' . arg
  endfor
  let path = system(cmd)
  if isdirectory(path)
    echo path
    exec 'edit' fnameescape(path)
  endif
endfunction

set diffopt+=vertical

" gvim options
if has('gui_running')
  set guifont="MesloLGS Nerd Font Mono"
  set guioptions-=m  "menu bar
  set guioptions-=T  "toolbar
  set guioptions-=r  "scrollbar
endif

let g:rooter_patterns = ['.git', '.git/']
let g:rooter_use_lcd = 1
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1

set nofixendofline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_symbols = {}
let g:airline_symbols.linenr = '¶'
let g:taboo_tabline = 0
let g:taboo_tab_format = "%f%m"
let g:taboo_renamed_tab_format = "%l%m"
"set clipboard=unnamedplus
set rtp+=~/.fzf

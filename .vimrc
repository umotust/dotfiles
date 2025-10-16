"@---------------------------------------------------------------
"@--- Plugin manager --------------------------------------------
"@---------------------------------------------------------------
if exists('$VIM_HOME')
  let g:vim_home = $VIM_HOME
else
  let g:vim_home = $HOME . '/.vim'
endif

let s:plug_path = expand(g:vim_home . '/autoload/plug.vim')
if filereadable(s:plug_path)
  execute 'source ' . fnameescape(s:plug_path)
endif

if !empty(glob(expand(g:vim_home . '/autoload/plug.vim')))
  call plug#begin(expand(g:vim_home . '/plugged'))
  Plug 'airblade/vim-gitgutter'             "@ status on left side
  Plug 'chase/vim-ansible-yaml'             "@ ansible
  Plug 'cocopon/iceberg.vim'                "@ color scheme
  Plug 'dzeban/vim-log-syntax'              "@ color .log
  Plug 'easymotion/vim-easymotion'          "@ move
  Plug 'editorconfig/editorconfig-vim'
  Plug 'Glench/Vim-Jinja2-Syntax'           "@ jinja
  Plug 'junegunn/fzf', {
        \'dir': '~/.fzf',
        \'do': './install --all' }          "@ search
  Plug 'junegunn/fzf.vim'                   "@ search
  Plug 'mechatroner/rainbow_csv'            "@ csv
  Plug 'nelstrom/vim-visual-star-search'
  Plug 'ntpeters/vim-better-whitespace'     "@ whitespace
  Plug 'rstacruz/sparkup', {'rtp:': 'vim/'} "@ path
  Plug 'Shougo/vimproc.vim',{
        \'do' : 'make' }                    "@ asynch for vim-quickrun
  Plug 't9md/vim-quickhl'                   "@ highlight
  Plug 'tpope/vim-commentary'               "@ comment
  Plug 'tpope/vim-fugitive'                 "@ git command
  Plug 'tpope/vim-surround'                 "@ surround
  Plug 'tpope/vim-repeat'                   "@ repeat for surround
  Plug 'vim-airline/vim-airline'            "@ status bar
  Plug 'thinca/vim-quickrun'                "@ run

  "@--- Language -------
  Plug 'aklt/plantuml-syntax'               "@ plantuml
  Plug 'brentyi/isort.vim'                  "@ isort
  Plug 'dylon/vim-antlr'                    "@ ANTLR
  Plug 'google/yapf', {
        \'rtp': 'plugins/vim',
        \'for': 'python' }                  "@ yapf
  Plug 'hashivim/vim-terraform'             "@ terraform
  Plug 'umotust/vim-clang-format'           "@ clang-format
  Plug 'vim-scripts/applescript.vim'        "@ applescript
  "@ Language Server Protocol
  if (v:version >= 901)
    let g:use_coc = 1
    "@ Configure in ~/.vim/coc-settings.json
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
  elseif (v:version >= 802)
    Plug 'prabirshrestha/asyncomplete.vim'     "@ completion
    Plug 'prabirshrestha/asyncomplete-lsp.vim' "@ completion
    Plug 'prabirshrestha/vim-lsp'              "@ lsp
    Plug 'mattn/vim-lsp-settings'              "@ lsp setting
    Plug 'mattn/vim-lsp-icons'                 "@ error
  elseif (v:version >= 800)
    Plug 'w0rp/ale'                         "@ linter
  else
    Plug 'vim-syntastic/syntastic'          "@ linter
  endif
  "@--- Language end ---

  call plug#end() " 'filetype plugin indent on', 'syntax enable' is executed automatically

  "@--- Plugin settings -------------------------------
  "@ fzf
  nnoremap [fzf] <Nop>
  nmap ,f [fzf]
  nnoremap <silent> [fzf]b :<C-u>Buffers<CR>
  nnoremap <silent> [fzf]f :<C-u>Files <C-R>=expand('%:h')<CR><CR>
  nnoremap <silent> [fzf]h :<C-u>History<CR>
  nnoremap <silent> [fzf]l :<C-u>Lines<CR>
  nnoremap <silent> [fzf]t :<C-u>Tags<CR>
  "@ ripgrep
  xnoremap [fzf] <Nop>
  xmap ,f [fzf]
  nnoremap <silent> [fzf]G :<C-u>SearchWord<CR>
  xnoremap <silent> [fzf]G :<C-u>SearchWord<CR>
  if executable('rg')
    nnoremap <silent> [fzf]g :<C-u>Rg<CR>
    command! -bang -nargs=? SearchWord
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always --smart-case -- .',
      \   fzf#vim#with_preview({'options': '--query=' . s:GetSearchWord()}),
      \   <bang>0)
  else
    nnoremap <silent> [fzf]g :<C-u>FzfGrepFallback<CR>
    command! -bang -nargs=? FzfGrepFallback
      \ call fzf#vim#grep(
      \   'grep -rnI .',
      \   fzf#vim#with_preview({'options': '--query=' . fzf#shellescape(<q-args>)}),
      \   <bang>0)
    command! -bang -nargs=? SearchWord
      \ call fzf#vim#grep(
      \   'grep -rnI .',
      \   fzf#vim#with_preview({'options': '--query=' . s:GetSearchWord()}),
      \   <bang>0)
  endif
  function! s:GetSearchWord() abort
    if visualmode() != ''
      return escape(s:GetVisualSelection(), ' ')
    endif
    return expand('<cword>')
  endfunction
  function! s:GetVisualSelection() abort
    let l:start = getpos("'<")
    let l:end   = getpos("'>")
    let l:lines = getline(l:start[1], l:end[1])
    " If selection is within a single line
    if len(l:lines) == 1
      return strpart(l:lines[0], l:start[2]-1, l:end[2]-l:start[2]+1)
    endif
    " Multi-line selection
    let l:lines[0] = strpart(l:lines[0], l:start[2]-1)
    let l:lines[-1] = strpart(l:lines[-1], 0, l:end[2])
    return join(l:lines, ' ')
  endfunction
  "@ whitespace
  let g:strip_whitespace_on_save = 1
  let g:strip_whitespace_confirm = 0
  "@ easymotion
  let g:EasyMotion_do_mapping = 0 " Disable default mappings
  map <Leader> <Plug>(easymotion-prefix)
  let g:EasyMotion_smartcase = 1
  map <Leader>e <Plug>(easymotion-bd-e)
  map <Leader>f <Plug>(easymotion-f)
  map <Leader>F <Plug>(easymotion-F)
  map <Leader>j <Plug>(easymotion-j)
  map <Leader>k <Plug>(easymotion-k)
  " map <Leader>l <Plug>(easymotion-bd-jk)
  map <Leader>s <Plug>(easymotion-s)
  map <Leader>w <Plug>(easymotion-bd-w)
  nmap <Leader>w <Plug>(easymotion-overwin-w)

  "@ color
  if has("termguicolors")
    set termguicolors
  endif
  if !empty(glob(expand(g:vim_home . "/plugged/iceberg.vim")))
    set background=dark
    colorscheme iceberg
  endif
  "set t_Co=256
  "syntax enable
  "@ gitgutter
  set updatetime=250
  "@ clang-format
  let g:clang_format#detect_style_file = 1
  "@ comment
  autocmd BufNewFile,BufRead *.log setlocal commentstring=#\ %s
  autocmd BufNewFile,BufRead *.adoc setlocal commentstring=//\ %s
  "@quickrun
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config._ = {
        \'outputter/buffer/into': 0,
        \'outputter/buffer/close_on_empty': 1,
        \'runner' : 'vimproc'}
  let g:quickrun_config.cpp = {
        \'cmdopt' : '-O3 -std=c++17' }
  let g:quickrun_config.python = {'command' : 'python3'}
  let g:quickrun_config.asciidoc = {
        \'command' : 'asciidoctor'}
  let g:quickrun_config.applescript = {
        \'command' : 'osascript',
        \'exec' : '%c %s' }
  nnoremap <Leader>r :<C-u>QuickRun<CR>
  "@ highlight
  nmap <Space>m <Plug>(quickhl-manual-this)
  xmap <Space>m <Plug>(quickhl-manual-this)
  nmap <Space>M <Plug>(quickhl-manual-reset)
  xmap <Space>M <Plug>(quickhl-manual-reset)
  "@ isort
  let g:vim_isort_python_version = 'python3'
  "@ lsp
  if exists('g:use_coc') && g:use_coc
    "@ coc.nvim
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    set signcolumn=yes
    inoremap <silent><expr> <TAB>
          \ coc#pum#visible() ? coc#pum#next(1) :
          \ CheckBackspace() ? "\<Tab>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
    inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    nmap <silent><nowait> gd <Plug>(coc-definition)
    nmap <silent><nowait> gi <Plug>(coc-implementation)
    nmap <silent><nowait> gr <Plug>(coc-references)
    nmap <silent><nowait> gy <Plug>(coc-type-definition)
    nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
    nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)
    nnoremap <silent> K :call ShowDocumentation()<CR>
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    command! -nargs=0 Format :call CocActionAsync('format')
    command! -nargs=? Fold   :call CocAction('fold', <f-args>)
    command! -nargs=0 OR     :call CocActionAsync('runCommand', 'editor.action.organizeImport')
  else
    "@ vim-lsp
    function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=yes
      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> gD <plug>(lsp-declaration)
      nmap <buffer> gr <plug>(lsp-references)
      nmap <buffer> gs <plug>(lsp-document-symbol-search)
      nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
      nmap <buffer> gi <plug>(lsp-implementation)
      nmap <buffer> [g <plug>(lsp-previous-diagnostic)
      nmap <buffer> ]g <plug>(lsp-next-diagnostic)
      nmap <buffer> K <plug>(lsp-hover)
      let g:lsp_format_sync_timeout = 200
      autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

      let l:capabilities = lsp#get_server_capabilities('ruff')
      if !empty(l:capabilities)
        let l:capabilities.hoverProvider = v:false
      endif
    endfunction
    if executable('ruff')
        au User lsp_setup call lsp#register_server({
            \ 'name': 'ruff',
            \ 'cmd': {server_info->['ruff', 'server']},
            \ 'allowlist': ['python'],
            \ 'workspace_config': {},
            \ })
    endif
    augroup lsp_install
        au!
        " call s:on_lsp_buffer_enabled only for languages that has the server registered.
        autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
    augroup END
    let g:lsp_diagnostics_enabled = 1
    let g:lsp_diagnostics_echo_cursor = 1
    let g:lsp_diagnostics_echo_delay = 200
    let g:lsp_document_highlight_enabled = 1
    let g:lsp_diagnostics_virtual_text_enabled = 0
    let g:asyncomplete_popup_delay = 200
    inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
  endif " !g:use_coc
  "@ ale
  let g:ale_sign_column_always = 1
  let g:ale_cpp_gcc_options = '-std=c++14'
  "@ syntastic
  let g:syntastic_cpp_compiler = 'clang++'
  let g:syntastic_cpp_compiler_options = ' -std=c++14 -stdlib=libc++'
endif "~/.vim/autoload/plug.vim
"@--- Plugin settings end ---------------------------
"@--- Plugin manager end -----------------------------------

set backspace=indent,eol,start
nnoremap Y y$

"@ encoding
set encoding=utf-8

"@ color
"colorscheme desert

"Transparency of iterm and Powerline-shell
highlight! Normal ctermbg=NONE guibg=NONE
highlight! NonText ctermbg=NONE guibg=NONE
highlight! LineNr ctermbg=NONE guibg=NONE

"@ display
set number
set cursorline
set laststatus=2 "@ display file name
set title        "@ display title
"set list         "@ invisible character
set showcmd
set display=lastline

"@ tab setting
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
autocmd FileType make setlocal noexpandtab softtabstop=0
autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4


"@ search
set incsearch
set hlsearch
set ignorecase
set smartcase " Ignore case when searching word is only lowercase with 'set ignorecase'
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>
autocmd QuickFixCmdPost *grep* cwindow

"@ visual mode
set virtualedit+=block

"@ sound
set belloff=all

"@ folding
set foldmethod=indent
set foldlevel=99
autocmd FileType json setlocal foldmethod=syntax

"@ window (arrow key)
nnoremap  <Left> <C-w>h
nnoremap  <Down> <C-w>j
nnoremap  <Up> <C-w>k
nnoremap  <Right> <C-w>l
nnoremap  <Home> <C-w><
nnoremap  <PageDown> <C-w>+
nnoremap  <PageUp> <C-w>-
nnoremap  <End> <C-w>>
set nocompatible
set splitright

"@ fast terminal connection
set ttyfast

"@ backup
"set noswapfile
"set nobackup

"@ syntax
autocmd BufNewFile,BufRead *.applescript  set filetype=applescript
autocmd BufNewFile,BufRead *.gitconfig*  set filetype=gitconfig
autocmd BufNewFile,BufRead *.service  set filetype=systemd
autocmd BufNewFile,BufRead *.*shrc*  set filetype=zsh

"@ lazygit
nnoremap <Leader>g :tab ter ++close env LANG=en lazygit<CR>

"@ netrw
let g:netrw_liststyle=3 " tree
let g:netrw_sizestyle="H" " (K, M, G)
let g:netrw_timefmt="%Y/%m/%d(%a) %H:%M:%S"
let g:netrw_banner=1
let g:netrw_preview=1
highlight NetrwMarkFile ctermfg=Yellow ctermbg=Red guifg=Yellow guibg=Red

"@clipboard
set clipboard+=unnamed

"@packages
packadd! termdebug

"@language
if !empty(systemlist('locale -a | grep -i "^en_US\.utf8$"'))
  language messages en_US.UTF-8
endif

"@ vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END

" Unified shortcut to close Quickfix, Location List, and Quickrun buffer
nnoremap <silent> <Leader>q :call CloseAllAuxWindows()<CR>
function! CloseAllAuxWindows()
  " Close Quickfix window if it is open
  if len(getqflist({'winid': 0})) > 0
    cclose
  endif

  " Close Location List window if it is open (current buffer)
  if len(getloclist(0)) > 0
    lclose
  endif

  " Close Quickrun output buffer if it exists
  let quickrun_buf = bufwinnr('quickrun://output')
  if quickrun_buf != -1
    bwipeout! quickrun://output
  endif
endfunction

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif

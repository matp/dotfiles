" basic settings {{{
  scriptencoding=utf8

  set backspace=indent,eol
  set nobackup
  set cpoptions+=$
  set noerrorbells
  set fileformats=unix,dos,mac
  set fillchars=vert:│,fold:-
  set hidden
  set ignorecase
  set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_,extends:❯,precedes:❮
  set shortmess+=I
  set smartcase
  set tags=tags;/

  if has('cmdline_info')
    set ruler showcmd
  endif

  if has('extra_search')
    set hlsearch incsearch
  endif

  if has('persistent_undo')
    set undofile undodir=~/.vim/undo

    if exists('*mkdir') && !isdirectory(&undodir)
      call mkdir(&undodir, 'p')
    endif
  endif

  if has('statusline')
    set laststatus=2

    function! StatusLine(active)
      if a:active
        let _  = '%1*%<%f %*'
        let _ .= '%2*%{exists("*fugitive#head") && fugitive#head() != ""'
          \ . ' ? "↯ " . fugitive#head() . " "'
          \ . ' : "" }'
        let _ .= '%2*%h%m%r%w%*'
        let _ .= '%2*%=%*'
        let _ .= '%2* %{join(filter([&fileformat, &fileencoding, &filetype],'
                   \ . ' "strlen(v:val)"), " │ ")} %*'
        let _ .= '%3* %4.(%p%%%) %*'
        let _ .= '%4* %5.(%l:%v%) %*'
        return _
      else
        let _  = '%5*%<%f %*'
        let _ .= '%5*%{exists("*fugitive#head") && fugitive#head() != ""'
          \ . ' ? "↯ " . fugitive#head() . " "'
          \ . ' : "" }'
        let _ .= '%5*%h%m%r%w%*'
        let _ .= '%5*%=%*'
        let _ .= '%5* %4.(%p%%%) %*'
        let _ .= '%5* %5.(%l:%v%) %*'
        return _
      endif
    endfunction

    function! StatusLineRefresh()
      for i in range(1, winnr('$'))
        call setwinvar(i, '&statusline', '%!StatusLine(' . (i == winnr()) . ')')
      endfor
    endfunction

    set statusline=%!StatusLine(1)
  endif

  if has('title')
    set title

    if $TERM_PROGRAM == 'Apple_Terminal'
      function! TitleUrlEncode(string)
        return substitute(a:string, '[^A-Za-z0-9_.~/-]',
          \ '\= "%" . printf("%02X", char2nr(submatch(0)))','g')
      endfunction

      function! TitleUrl()
        return bufname('%') == ''
          \ ? ''
          \ : 'file://' . hostname() . TitleUrlEncode(expand('%:p'))
      endfunction

      set t_ts=]6;
      set t_fs=
      set titlestring=%{TitleUrl()}
      set titlelen=0
    else
      set titlestring=%f\ %h%m%r%w
    endif
  endif

  if has('wildmenu')
    set wildmenu wildmode=list:longest

    if has('wildignore')
      set wildignore+=tags,.DS_Store,.git,.hg,.svn,*~,*.class,*.d,*.o,*.pyc
    endif
  endif
" }}}

" bootstrap vim-plug {{{
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
  endif
" }}}

" configure plugins {{{
  call plug#begin('~/.vim/plugged')

  " basic plugins
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-characterize'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-speeddating'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'godlygeek/tabular'

  " tree explorer
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }

  " tab completion
  Plug 'ajh17/VimCompletesMe'

  " version control
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter', { 'on': 'GitGutterToggle' }

  " color schemes
  Plug 'morhetz/gruvbox'
  Plug 'ap/vim-css-color'

  " language support
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
  Plug 'hail2u/vim-css3-syntax', { 'for': ['html', 'css', 'scss'] }
  Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
  Plug 'elixir-lang/vim-elixir', { 'for': ['elixir', 'eelixir'] }
  Plug 'tikhomirov/vim-glsl', { 'for': 'glsl' }
  Plug 'fatih/vim-go', { 'for': 'go' }
  Plug 'tpope/vim-haml', { 'for': ['haml', 'sass', 'scss'] }
  Plug 'neovimhaskell/haskell-vim', { 'for': ['haskell', 'lhaskell', 'cabal'] }
  Plug 'othree/html5.vim', { 'for': ['html', 'javascript'] }
  Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx'] }
  Plug 'elzr/vim-json', { 'for': 'json' }
  Plug 'mxw/vim-jsx', { 'for': ['javascript', 'javascript.jsx'] }
  Plug 'StanAngeloff/php.vim', { 'for': 'php' }
  Plug 'tpope/vim-rails', { 'for' : ['ruby', 'eruby'] }
  Plug 'tpope/vim-rake', { 'for' : ['ruby', 'eruby'] }
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  Plug 'keith/swift.vim', { 'for': 'swift' }
  Plug 'cespare/vim-toml', { 'for': 'toml' }
  Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

  call plug#end()

  " NERDTree settings
  let g:NERDTreeQuitOnOpen=1
  let g:NERDTreeMinimalUI=1
  let g:NERDTreeWinSize=26

  " GitGutter settings
  let g:gitgutter_enabled = 0
" }}}

" syntax highlighting {{{
  silent! colorscheme gruvbox

  if exists('g:colors_name')
    if g:colors_name == "gruvbox"
      let g:gruvbox_termcolors=16
      let g:gruvbox_italic=0
      set background=dark
    endif
  endif

  " language settings
  let g:c_no_curly_error = 1

  " enable syntax highlighting
  syntax enable

  " status line colors
  highlight User1 cterm=bold ctermfg=15 ctermbg=237
  highlight User2 ctermfg=7 ctermbg=237
  highlight User3 ctermfg=0 ctermbg=7
  highlight User4 ctermfg=0 ctermbg=15
  highlight User5 ctermfg=7 ctermbg=236
" }}}

" key mappings {{{
  let mapleader=','

  " basic mappings
  nnoremap Y y$
  xnoremap < <gv
  xnoremap > >gv
  cnoremap w!! w !sudo dd of=%

  " buffer navigation
  nnoremap <Leader><Leader> <C-^>

  " GitGutter
  nnoremap <Leader>g :GitGutterToggle<CR>

  " NERDTree
  nnoremap <Leader>e :NERDTreeToggle<CR>
  nnoremap <Leader>f :NERDTreeFind<CR>

  " Tabularize
  nnoremap <Leader>a= :Tabularize /=<CR>
  xnoremap <Leader>a= :Tabularize /=<CR>
  nnoremap <Leader>a: :Tabularize /:\zs<CR>
  xnoremap <Leader>a: :Tabularize /:\zs<CR>
  nnoremap <Leader>a<Bar> :Tabularize /\|<CR>
  xnoremap <Leader>a<Bar> :Tabularize /\|<CR>
" }}}

" auto commands {{{
  if has('autocmd')
    filetype indent off

    augroup vimrc
      autocmd!

      " indentation
      autocmd FileType *
        \ setlocal formatoptions-=ro noautoindent nocindent nosmartindent
      autocmd FileType c,javascript,ruby,scala,sml,swift,vim
        \ setlocal shiftwidth=2 softtabstop=2 expandtab
      autocmd FileType css,eruby,html,java,php,python,sass,scss,typescript
        \ setlocal shiftwidth=4 softtabstop=4 expandtab

      " language settings
      autocmd FileType css,less,sass,scss setlocal iskeyword+=-
      autocmd FileType vim setlocal keywordprg=:help

      " file types
      autocmd BufNewFile,BufReadPost *.md set filetype=markdown

      " diff mode
      autocmd BufWritePost * if &diff | diffupdate | endif

      " status line
      if exists('*StatusLineRefresh')
        autocmd VimEnter,WinEnter,BufWinEnter * call StatusLineRefresh()
      endif
    augroup END
  endif
" }}}

" vim:foldmethod=marker

let $RUBYHOME=$HOME."/.rbenv/versions/2.3.5"
set rubydll=$HOME/.rbenv/versions/2.3.5/lib/libruby.2.3.5.dylib
set nocompatible               " be iMproved
filetype off                   " required!
set t_Co=256

" use system clipboard on osx
set clipboard=unnamed

set hidden

" Include user's local vim config
if filereadable(expand("~/.vim/vundle.config"))
  source ~/.vim/vundle.config
endif

" Set leader to ,
let mapleader=','

" use arrows to switch buffers
nmap <silent> <S-w> :bn<CR>
nmap <silent> <S-q> :bp<CR>

" use arrow to switch windows
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>

" better movement in wrapped lines
map j gj
map k gk

" write with sudo
cmap w!! W !sudo tee % >/dev/null

" delete buffer, keep split-window
map ,d :b#<bar>bd#<CR>

" Show YankRing
nnoremap <silent> <leader>y :YRShow<CR>

" clear search highlighting
nmap <silent> <leader>/ :nohlsearch<CR>

" Fast editing and reloading of the .vimrc
map <leader>e :e! ~/.vim/vimrc<cr>
autocmd! bufwritepost vimrc source ~/.vim/vimrc

" some visual helpers
set number
set ruler
syntax on
set wrap
set tw=0
let g:solarized_contrast="high"
let g:solarized_visibility="high"
let g:solarized_hitrail=1
let g:solarized_termtrans=1
colorscheme desert
set background=light

" Status line
let g:airline_theme="cool"
let g:airline_left_sep = '⮀'
let g:airline_left_alt_sep = '⮁'
let g:airline_right_sep = '⮂'
let g:airline_right_alt_sep = '⮃'

set showmatch
set mat=2

" Set encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,default,latin1

" Whitespace stuff
set nowrap
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list listchars=tab:\ \ ,nbsp:_,trail:·

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Status bar
set laststatus=2
" Show (partial) command in the status line
set showcmd

"Load Fugitive
let g:statusline_fugitive = 1
"Load RVM
let g:statusline_rvm = 1
"Do Not Load Syntastic
let g:statusline_syntastic = 1

" NERDTree configuration
let NERDTreeIgnore=['\.pyc$', '\.rbc$', '\~$']
map <Leader>n :NERDTreeToggle<CR>

" Command-T configuration
let g:CommandTMaxHeight=20

" CTRL-P configuration
let g:ctrlp_map = '<c-x>' " map to ctrl-x
let g:ctrlp_by_filename = 0 " make filename mode standard
let g:ctrlp_match_window_reversed = 1 " reverse match sort order
let g:ctrlp_working_path_mode = 2 " find working-directory
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|log$\|node_modules$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$',
  \ 'link': 'some_bad_symbolic_link',
  \ }

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" make uses real tabs
au FileType make set noexpandtab

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby
au BufRead,BufNewFile *.{pill}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} call s:setupMarkup()

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

au BufRead,BufNewFile *.es6 set ft=javascript

"au BufRead,BufNewFile *.txt call s:setupWrapping()

" python support
" --------------
"  don't highlight exceptions and builtins. I love to override them in local
"  scopes and it sucks ass if it's highlighted then. And for exceptions I
"  don't really want to have different colors for my own exceptions ;-)
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
let python_highlight_all=1
let python_highlight_exceptions=0
let python_highlight_builtins=0
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" template language support (SGML / XML too)
" ------------------------------------------
" and disable taht stupid html rendering (like making stuff bold etc)
fun! s:SelectHTML()
let n = 1
while n < 50 && n < line("$")
  " check for jinja
  if getline(n) =~ '{%\s*\(extends\|block\|macro\|set\|if\|for\|include\|trans\)\>'
    set ft=htmljinja
    return
  endif
  " check for mako
    if getline(n) =~ '<%\(def\|inherit\)'
      set ft=mako
      return
    endif
    " check for genshi
    if getline(n) =~ 'xmlns:py\|py:\(match\|for\|if\|def\|strip\|xmlns\)'
      set ft=genshi
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun

autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()

let g:prettier#autoformat=0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md PrettierAsync

" epub support
au BufReadCmd *.epub call zip#Browse(expand("<amatch>"))

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" load the plugin and indent settings for the detected filetype
filetype plugin indent on

" Enable syntastic syntax checking
let g:syntastic_enable_signs=1
let g:syntastic_quiet_messages = {'level': 'warnings'}

" gist-vim defaults
if has("mac")
  let g:gist_clip_command = 'pbcopy'
elseif has("unix")
  let g:gist_clip_command = 'xclip -selection clipboard'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Use modeline overrides
set modeline
set modelines=10

" Directories for swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

set noswapfile

set undodir=~/.vim/undodir
set undofile

" Turn off jslint errors by default
let g:JSLintHighlightErrorLine = 0

" MacVIM shift+arrow-keys behavior (required in .vimrc)
let macvim_hig_shift_movement = 1

" RSpec in quickfix window
function! RSpec(command)
  " TODO: handle args such as --tag focus here, or make a separate command for it
  if a:command == ''
    let dir = 'spec'
  else
    let dir = a:command
  endif
  cexpr system("rspec -r ~/.rspecformatters/vim_formatter -f RSpec::Core::Formatters::VimFormatter " . dir)
  cw
endfunction
command! -nargs=? -complete=file Spec call RSpec(<q-args>)
map <leader>s :Spec<space>

" Disable LustyJuggler ruby warning
let g:LustyJugglerSuppressRubyWarning=1

" Replace word under cursor
:nmap <leader>s :s/\(<c-r>=expand("<cword>")<cr>\)/

" Ack word under cursor
:nmap <leader>a :Ack <c-r>=expand("<cword>")<cr>

" MiniBufExplorer config
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplSplitBelow=0

autocmd BufRead,BufNew :call UMiniBufExplorer

map <leader>m :TMiniBufExplorer<cr>

" Omnicomplete
autocmd BufRead,BufNewFile *.scss set filetype=scss
autocmd FileType {css,scss} set omnifunc=csscomplete#CompleteCSS

" Automatically equalize splits
autocmd VimResized * wincmd =

" switch.vim
nnoremap - :Switch<cr>

" vimux
" Run the current file with rspec
map <Leader>rb :call VimuxRunCommand("clear; nocorrect bundle exec rspec " . bufname("%"))<CR>

" Prompt for a command to run
map <Leader>rp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>rl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>ri :VimuxInspectRunner<CR>

" Close all other tmux panes in current window
map <Leader>rx :VimuxClosePanes<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>rq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>rs :VimuxInterruptRunner<CR>

augroup DeleteTrailingWhitespacesAndPreserveEOL
  autocmd!
  autocmd BufWritePre  * call DeleteTrailingWhitespaces()
  autocmd BufWritePre  * call <SID>TempSetBinaryForNoeol()
  autocmd BufWritePost * call <SID>TempRestoreBinaryForNoeol()
augroup END

" http://vim.wikia.com/wiki/Preserve_missing_end-of-line_at_end_of_text_files
function! s:TempSetBinaryForNoeol()
  let s:save_binary = &binary
  if ! &eol && ! &binary
    let s:save_view = winsaveview()
    setlocal binary
    if &ff == "dos" || &ff == "mac"
      if line('$') > 1
        undojoin | exec "silent 1,$-1normal! A\<C-V>\<C-M>"
      endif
    endif
    if &ff == "mac"
      undojoin | %join!
      " mac format does not use a \n anywhere, so we don't add one when writing
      " in binary (which uses unix format always). However, inside the outer
      " if statement, we already know that 'noeol' is set, so no special logic
      " is needed.
    endif
  endif
endfun

function! s:TempRestoreBinaryForNoeol()
  if ! &eol && ! s:save_binary
    if &ff == "dos"
      if line('$') > 1
        " Sometimes undojoin gives errors here, even when it shouldn't.
        " Suppress them for now...if you can figure out and fix them instead,
        " please update http://vim.wikia.com/wiki/VimTip1369
        silent! undojoin | silent 1,$-1s/\r$//e
      endif
    elseif &ff == "mac"
      " Sometimes undojoin gives errors here, even when it shouldn't.
      " Suppress them for now...if you can figure out and fix them instead,
      " please update http://vim.wikia.com/wiki/VimTip1369
      silent! undojoin | silent %s/\r/\r/ge
    endif
    setlocal nobinary
    call winrestview(s:save_view)
  endif
endfun

function! DeleteTrailingWhitespaces()
  let here = getpos(".")
  execute "%s/\\s\\+$//ge"
  let last_search_removed_from_history = histdel('s', -1)
  call setpos('.', here)
endfunction

" ale fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'ruby': ['rubocop'],
\}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_executable = '/usr/local/bin/prettier'
let g:ale_javascript_prettier_use_global = 1

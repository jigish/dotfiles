" plugins ---------------------------------------------------------------------------------------------------

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" syntax & language plugins
Plug 'sheerun/vim-polyglot'
Plug 'saltstack/salt-vim'
Plug 'tfnico/vim-gradle'
Plug 'bendavis78/vim-polymer'

" basics & dependencies
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" color schemes
Plug 'gregsexton/Muon'

" extra features
Plug 'airblade/vim-gitgutter'
Plug 'brettanomyces/nvim-terminus'
Plug 'Chiel92/vim-autoformat'
Plug 'jigish/vim-eclim', { 'for' : ['java', 'jsp', 'scala', 'clojure', 'groovy', 'gradle'] }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'mattn/vim-javafmt'
Plug 'mhinz/vim-grepper'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tmhedberg/matchit'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" TODO syntastic -> neomake
" AnsiEsc?
" LargeFile?
" paredit?

call plug#end()

command! PU PlugUpdate | PlugUpgrade

" basic configs ---------------------------------------------------------------------------------------------

" ensure the temporary directories exist and change where we store backup/swap/undo files
call system("mkdir -p ~/.config/nvim/tmp/backup")
call system("mkdir -p ~/.config/nvim/tmp/swap")
call system("mkdir -p ~/.config/nvim/tmp/undo")
set backupdir=~/.config/nvim/tmp/backup/
set dir=~/.config/nvim/tmp/swap/
set undodir=~/.config/nvim/tmp/undo/

set completeopt-=preview
set expandtab
set formatoptions=croql
set hidden
set ignorecase
set linespace=1
set list
set listchars=tab:▸\ ,eol:¬
set noeb vb t_vb=
set number
set scrolloff=3
set shortmess=atI
set smartcase
set smartindent
set splitbelow
set splitright
set sts=2
set sw=2
set tags+=.tags
set textwidth=120
set title
set ts=2
set ttimeout
set ttimeoutlen=0
set undofile
set wildmode=list:longest,full

let &wrapmargin= &textwidth
let mapleader=","

" go specific settings
augroup golang
  au!
  au FileType go setlocal noexpandtab
augroup END

augroup java
  au!
  au FileType java setlocal sts=4
  au FileType java setlocal sw=4
  au FileType java setlocal ts=4
augroup END

" auto-open quick fix window on make and such
" TODO do I need this for neovim?
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" set terminal history to super long
let g:terminal_scrollback_buffer_size = 2147483647

" colors ----------------------------------------------------------------------------------------------------

set t_Co=256
set background=dark
colorscheme muon
let g:airline_theme='raven'

" fix NonText and SpecialKey (equivalent to Comment)
hi NonText ctermfg=240 ctermbg=234 gui=None guifg=#585858 guibg=#1c1c1c
hi SpecialKey ctermfg=240 ctermbg=234 gui=None guifg=#585858 guibg=#1c1c1c

" fix sign column colors
let g:gitgutter_override_sign_column_highlight=0
hi SignColumn            ctermbg=bg
hi GitGutterAdd          ctermfg=086
hi GitGutterChange       ctermfg=214
hi GitGutterDelete       ctermfg=161
hi GitGutterChangeDelete ctermfg=166

" show extra whitespace
hi ExtraWhitespace guibg=#CCCCCC
hi ExtraWhitespace ctermbg=161
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" color column
function! ToggleColorColumn()
  if &colorcolumn == 0
    " Draw the color column wherever wrapmargin is set
    let &colorcolumn = &wrapmargin
  else
    let &colorcolumn = 0
  endif
endfunction
command! ToggleColorColumn call ToggleColorColumn()
call ToggleColorColumn()

" basic mappings --------------------------------------------------------------------------------------------

" fucking arrow keys
nnoremap <Up> <ESC>
nnoremap <Down> <ESC>
nnoremap <Left> <ESC>
nnoremap <Right> <ESC>
inoremap <Up> <ESC>
inoremap <Down> <ESC>
inoremap <Left> <ESC>
inoremap <Right> <ESC>

" my fingers are slow. bind :W to :w & :Q to :q & :Wq to :wq & :Wa to :wa
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))
cnoreabbrev <expr> Wq ((getcmdtype() is# ':' && getcmdline() is# 'Wq')?('wq'):('Wq'))
cnoreabbrev <expr> Wa ((getcmdtype() is# ':' && getcmdline() is# 'Wa')?('wa'):('Wa'))

" caleb's cool s and S mappings
nnoremap s i<CR><ESC>==
nnoremap S d$O<ESC>p==

" yank to and paste from clipboard
vnoremap <leader>yc "*y
nnoremap <leader>yv "*p

" command to delete all trailing whitespace from a file.
command! DeleteTrailingWhitespace %s:\(\S*\)\s\+$:\1:
nnoremap <silent><F6> :DeleteTrailingWhitespace<CR>

" color column toggle
map <leader>c :ToggleColorColumn<CR>

" buffer management
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bD :bdelete!<CR>
nnoremap <leader>bc :bdelete<CR>
nnoremap <leader>bC :bdelete!<CR>
nnoremap <leader>fD :call delete(@%)<CR>:bdelete!<CR>

" exec
nnoremap <leader>ee ^y$:!<c-r>0<CR>

" terminal/split awesomeness
tnoremap <M-c> <C-\><C-n>
tnoremap <M-x> <C-\><C-n>
tnoremap <M-h> <C-\><C-n><C-w>h
tnoremap <M-j> <C-\><C-n><C-w>j
tnoremap <M-k> <C-\><C-n><C-w>k
tnoremap <M-l> <C-\><C-n><C-w>l
nnoremap <M-h> <C-w>h
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-l> <C-w>l
nnoremap <M-d> :vsplit<CR>
nnoremap <M-D> :split<CR>
tnoremap <M-d> <C-\><C-n>:vsplit<CR>:terminal<CR>
tnoremap <M-T> <C-\><C-n>:split<CR>:terminal<CR>
nnoremap <M-t> :vsplit<CR>:terminal<CR>
nnoremap <M-T> :split<CR>:terminal<CR>
tnoremap <M-t> <C-\><C-n>:vsplit<CR>:terminal<CR>
tnoremap <M-T> <C-\><C-n>:split<CR>:terminal<CR>

" ctags
map <leader>tw yiw:tag <c-r>0<CR>
map <leader>ts :ts<CR>
map <leader>tn :tn<CR>
map <leader>tp :tp<CR>
map <leader>tf :tf<CR>
map <leader>tl :tl<CR>
map <leader>tt :pop<CR>

" ruby: convert strings to symbols and visa-versa
nnoremap <leader>sw" :silent! normal ds"<ESC>i:<ESC>
nnoremap <leader>sw' :silent! normal ds'<ESC>i:<ESC>
nnoremap <leader>ss" :silent! normal ysiw"<ESC>:silent! normal hx<ESC>
nnoremap <leader>ss' :silent! normal ysiw'<ESC>:silent! normal hx<ESC>

" plugin config ---------------------------------------------------------------------------------------------

" reload files (refresh ctags, nerdtree, fzf)
function! ReloadTags()
  call jobstart(['ctags', '-f', '.tags', '-R', '.'])
endfunction
command! ReloadTags call ReloadTags()
nnoremap <silent><F5> :ReloadTags<CR>:NERDTree<CR>:NERDTreeToggle<CR>

" airline
let g:airline_powerline_fonts=1

" eclim
au BufEnter *.java map <leader>tw :JavaSearch<CR>
au BufEnter *.scala map <leader>tw :ScalaSearch<CR>
au BufLeave *.java,*.scala map <leader>tw yiw:tag <c-r>0<CR>
let g:EclimJavaSearchSingleResult='edit'
let g:EclimScalaSearchSingleResult='edit'
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimHtmlValidate = 0
let g:EclimJavascriptValidate = 0
map <leader>eo :ProjectImport .<CR>:ProjectOpen<CR>
map <leader>er :ProjectDelete <c-r>=expand('%:p:h:t')<CR><CR>:ProjectImport .<CR>:ProjectOpen<CR>
vnoremap <leader>jg :JavaGetSet<CR>
map <leader>jc :JavaConstructor<CR>
map <leader>ji :JavaImport<CR>
map <leader>jo :JavaImportOrganize<CR>
map <leader>jf :JavaFmt<CR>

" fugitive
map <leader>gs :Gstatus<CR>
map <leader>gc :Gcommit<CR>
map <leader>gp :Git push<CR>
map <leader>gP :Git pull<CR>
map <leader>gl :Git pull<CR>
map <leader>gd :Gdiff<CR>
map <leader>gb :Gblame<CR>
map <leader>ga :Git add .<CR>
map <leader>gr :!spr<CR>
map <leader>spr :!spr<CR>
nnoremap <leader>gD <c-w>h<c-w>c

" fzf
let g:fzf_command_prefix = 'Fzf'
nnoremap <silent><C-p> :call fzf#vim#files('', {'down': '40%', 'source': 'find . -name .git -prune -o -name .svn -prune -o -name .hg -prune -o -name .gradle -prune -o -name .settings -prune -o -name build -prune -o -name bin -prune -o -path "./**/compiled" -prune -o -type f'})<CR>
nnoremap <silent><M-p> :call fzf#vim#files('', {'down': '40%', 'source': 'find . -name .git -prune -o -name .svn -prune -o -name .hg -prune -o -name .gradle -prune -o -name .settings -prune -o -name build -prune -o -name bin -prune -o -path "./**/compiled" -prune -o -type f'})<CR>
nnoremap <silent><C-g> :FzfGitFiles<CR>
nnoremap <silent><M-g> :FzfGitFiles<CR>
nnoremap <silent><C-b> :FzfBuffers<CR>
nnoremap <silent><M-b> :FzfBuffers<CR>
nnoremap <silent><C-t> :FzfTags<CR>

" git gutter
map <leader>gg :GitGutterToggle<CR>
map <leader>gr :GitGutterToggle<CR>:GitGutterToggle<CR>

" grepper
map <leader>aw :Grepper -tool pt -cword -noprompt<CR>
map <leader>aa :Grepper -tool pt<CR>
map <leader>ag :Grepper -tool git<CR>

" TODO make/neomake
nnoremap <leader>mm :wa<CR>:make<CR>
nnoremap <leader>mc :wa<CR>:make clean<CR>
nnoremap <leader>mt :wa<CR>:make test<CR>
nnoremap <leader>mf :wa<CR>:make fmt<CR>
autocmd! BufWritePost *.go Neomake

" nerdtree
let g:NERDTreeChDirMode=2
let g:NERDChristmasTree=1
nmap <leader>t :NeoBundleSource nerdtree<CR>:NERDTreeToggle<CR>
" Exit vim if NERDTree is the last window open
au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" tagbar
map <leader>tb :TagbarToggle<CR>

" javafmt
let g:javafmt_options='-a'

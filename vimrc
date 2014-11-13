execute pathogen#infect()
"filetype plugin indent on

set mouse=a                 " enable mouse use in all modes
set noeb                    " no errorbells sound
set novb                    " no visualbells
set encoding=utf-8          " set file encoding
setglobal fileencoding=utf-8 " set file encoding
set termencoding=utf-8      
set background=dark
colorscheme solarized
set selectmode=mouse

set laststatus=2            " always show status line
set ruler                   " show cursor position (overriden by statusline)
set showcmd                 " show partial command in bottom-right
set showtabline=1           " show tabline only when more than one tab exists

set wildmenu                " use tab completion on command line
set autoread                " reload unchanged buffers when files changed outside vim

set nocompatible            " prevent unexpected things
set number                  " line numbering
set cul                     "highlight current line


set autoindent              " preserve indent level on new lines
set tabstop=4               " a tab is 4 spaces
set softtabstop=4           " num of column vim uses when tab is hit
set shiftwidth=4            " autoindent with << is 4 spaces
set expandtab               " use spaces, not tabs
set smarttab                " use shiftwidth/tabstop based on context

set smartindent             " smartly indents

set incsearch               " incremental searching
set hlsearch                " highlight matchesj
set ignorecase              " case insensitive...
set smartcase               " ...unless they contain at least one capital letter

" statusline
" " cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" " format markers:
" "   %< truncation point
" "   %n buffer number
" "   %f relative path to file
" "   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
" "   %r readonly flag [RO]
" "   %y filetype [ruby]
" "   %= split point for left and right justification
" "   %-35. width specification
" "   %l current line number
" "   %L number of lines in buffer
" "   %c current column number
" "   %V current virtual column number (-n), if different from %c
" "   %P percentage through buffer
" "   %) end of width specification
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

set shiftround " when at 3 spaces and I hit >>, go to 4, not 5

autocmd vimenter * if !argc() | NERDTree | endif

if has('autocmd')
    filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8                     " better default than latin1
  setglobal fileencoding=utf-8           " change default file encoding when writing new files
  set fileencodings=ucs-bom,utf8,prc,latin1
endif


let mapleader = ","             " define map leader

" CTRL-N is to search a word 
map <C-N> ve<C-C>/<C-V><CR>
map <F1>	:q<CR>
map <F2>	:w!<CR>
map <F3>    :n<CR>
map <F4>    :N<CR>
" diff
" jump forwards to the previous start of a change
map <F5>        ]c
" jump backwards to the previous start of a change
map <F6>        [c
" diffput
map <F7>        dp
" tab movements
map <C-Tab>     :tabn<ENTER>
map <C-S-TAB>   :tabp<ENTER>
map <Tab>       :bn<ENTER>

" when creating a window, want to move to the created window
map <C-W>v      <C-W><C-V>
map <C-W>s      <C-W><C-S>
map <C-W><C-V>  <C-W><C-V><C-W><C-L>
map <C-W><C-S>  <C-W><C-S><C-W><C-J>

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" cause I always capitalize accidentally
map :W  :w

" cause dont use space when out of insert mode
map <SPACE> :
" playback with Q
nnoremap Q @q
" copy text to end of line to be consistent
nnoremap Y y$

" merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  split
  execute "buffer " . bufferName
endfunction 

map :merge      :call MergeTabs()


" Easy motion specific
" Gif config
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" git gutter commands
map :gitd :GitGutterDisable
map :gite :GitGutterEnable
map :gitt :GitGutterToggle

hi clear SignColumn

map <Leader>e $
map <Leader>f ^
map <Leader>b ^

" mapping paste to conventional commands
nmap <C-V> "+p
imap <C-V> <C-R>+
" mapping copy to conventional commands
vmap <C-C> "+y

" map CTRL+L to last edited line
nmap <C-L> g;

" BASH-SUPPORT
let g:BASH_AuthorName   = 'Harrison Wang'
let g:BASH_Email        = 'h.wang94@yahoo.com'

"====================
"Shortcut comments
"====================
" # - Normal Mode: Highlights all words under cursor
" ^ - Normal Mode: Beginning of line
" $ - Normal Mode: End of line
execute pathogen#infect()
"filetype plugin indent on

set mouse=a                 " enable mouse use in all modes
set noeb                    " no errorbells sound
set novb                    " no visualbells
set encoding=utf-8          " set file encoding
setglobal fileencoding=utf-8 " set file encoding
set termencoding=utf-8      
set background=dark
colorscheme solarized
set selectmode=mouse

set laststatus=2            " always show status line
set ruler                   " show cursor position (overriden by statusline)
set showcmd                 " show partial command in bottom-right
set showtabline=1           " show tabline only when more than one tab exists

set wildmenu                " use tab completion on command line
set autoread                " reload unchanged buffers when files changed outside vim

set nocompatible            " prevent unexpected things
set number                  " line numbering
set cul                     "highlight current line


set autoindent              " preserve indent level on new lines
set tabstop=4               " a tab is 4 spaces
set softtabstop=4           " num of column vim uses when tab is hit
set shiftwidth=4            " autoindent with << is 4 spaces
set expandtab               " use spaces, not tabs
set smarttab                " use shiftwidth/tabstop based on context

set smartindent             " smartly indents

set incsearch               " incremental searching
set hlsearch                " highlight matchesj
set ignorecase              " case insensitive...
set smartcase               " ...unless they contain at least one capital letter

" statusline
" " cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" " format markers:
" "   %< truncation point
" "   %n buffer number
" "   %f relative path to file
" "   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
" "   %r readonly flag [RO]
" "   %y filetype [ruby]
" "   %= split point for left and right justification
" "   %-35. width specification
" "   %l current line number
" "   %L number of lines in buffer
" "   %c current column number
" "   %V current virtual column number (-n), if different from %c
" "   %P percentage through buffer
" "   %) end of width specification
set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)

set shiftround " when at 3 spaces and I hit >>, go to 4, not 5

autocmd vimenter * if !argc() | NERDTree | endif

if has('autocmd')
    filetype plugin indent on
endif

if has('syntax') && !exists('g:syntax_on')
    syntax enable
endif

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8                     " better default than latin1
  setglobal fileencoding=utf-8           " change default file encoding when writing new files
  set fileencodings=ucs-bom,utf8,prc,latin1
endif


let mapleader = ","             " define map leader

" CTRL-N is to search a word 
map <C-N> ve<C-C>/<C-V><CR>
map <F1>	:q<CR>
map <F2>	:w!<CR>
map <F3>    :n<CR>
map <F4>    :N<CR>
" diff
" jump forwards to the previous start of a change
map <F5>        ]c
" jump backwards to the previous start of a change
map <F6>        [c
" diffput
map <F7>        dp
" tab movements
map <C-Tab>     :tabn<ENTER>
map <C-S-TAB>   :tabp<ENTER>
map <Tab>       :bn<ENTER>

" when creating a window, want to move to the created window
map <C-W>v      <C-W><C-V>
map <C-W>s      <C-W><C-S>
map <C-W><C-V>  <C-W><C-V><C-W><C-L>
map <C-W><C-S>  <C-W><C-S><C-W><C-J>

" disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

if has("statusline")
 set statusline=%<%f\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" cause I always capitalize accidentally
map :W  :w

" cause dont use space when out of insert mode
map <SPACE> :
" playback with Q
nnoremap Q @q
" copy text to end of line to be consistent
nnoremap Y y$

" merge a tab into a split in the previous window
function! MergeTabs()
  if tabpagenr() == 1
    return
  endif
  let bufferName = bufname("%")
  if tabpagenr("$") == tabpagenr()
    close!
  else
    close!
    tabprev
  endif
  split
  execute "buffer " . bufferName
endfunction 

map :merge      :call MergeTabs()


" Easy motion specific
" Gif config
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" Gif config
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" git gutter commands
map :gitd :GitGutterDisable
map :gite :GitGutterEnable
map :gitt :GitGutterToggle

hi clear SignColumn

map <Leader>e $
map <Leader>f ^
map <Leader>b ^

" mapping paste to conventional commands
nmap <C-V> "+p
imap <C-V> <C-R>+
" mapping copy to conventional commands
vmap <C-C> "+y

" map CTRL+L to last edited line
nmap <C-L> g;

" BASH-SUPPORT
let g:BASH_AuthorName   = 'Harrison Wang'
let g:BASH_Email        = 'h.wang94@yahoo.com'

"====================
"Shortcut comments
"====================
" # - Normal Mode: Highlights all words under cursor
" ^ - Normal Mode: Beginning of line
" $ - Normal Mode: End of line
" :r - Command Mode: Read ________

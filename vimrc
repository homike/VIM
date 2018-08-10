set nocompatible
filetype off 

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/home/moyu/.fzf/
call vundle#begin()

" tool
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-sensible'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/a.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
"Plugin 'Shougo/neocomplcache.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'fatih/vim-go'
Plugin 'nsf/gocode', {'rtp': 'vim/'}

" colorscheme
Plugin 'sickill/vim-monokai'
Plugin 'notpratheek/vim-luna'
Plugin 'altercation/vim-colors-solarized'

"Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'Chun-Yang/vim-action-ag'
"Plugin 'Yggdroot/LeaderF', { 'do': '.\install.bat' }
"Plugin 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plugin 'junegunn/fzf.vim'
Plugin 'wsdjeg/FlyGrep.vim'

call vundle#end()
filetype plugin indent on

" tagbar
let g:tagbar_ctags_bin = 'ctags'
let g:tagbar_width = 25
let g:Lf_ShortcutF = '<C-P>'
map <F2> :Tagbar<CR>
map <C-x> :!ctags -R<CR>

" nerdtree
let NERDTreeWinPos = 'left'
let NERDTreeWinSize = 25
let NERDTreeIgnore = ['\.pyc']
map <F3> :NERDTreeToggle<CR>

" tab
map <C-l> :tabn<CR>
map <C-k> :tabnew<CR>
" fzf
map <C-p> :Files<CR>

" neocomplcache
"let g:acp_enableAtStartup = 0
"let g:neocomplcache_min_keyword_length = 3
"let g:neocomplcache_min_syntax_length = 3
"let g:neocomplcache_enable_at_startup = 1

"autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" airline
let g:airline_powerline_fonts = 0
let g:airline_theme = 'bubblegum'
let g:airline#extensions#whitespace#enabled = 0
let g:airline_powerline_fonts = 1 

" cpp build
map <C-a> :call CppBuild()<CR>
function CppBuild()
    execute "!g++ % -Wall -std=c++11 -ggdb -gdwarf-2 -o %<"
endfunction

" make tabline in terminal mode
function! Vim_NeatTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'
        " the label is made by MyTabLabel()
        let s .= ' %{Vim_NeatTabLabel(' . (i + 1) . ')} '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999XX'
    endif
    return s
endfunc
 
" get a single tab name 
function! Vim_NeatBuffer(bufnr, fullname)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
        if l:name == ''
            return '[No Name]'
        else
            if a:fullname 
                return fnamemodify(l:name, ':p')
            else
                return fnamemodify(l:name, ':t')
            endif
        endif
    else
        let l:buftype = getbufvar(a:bufnr, '&buftype')
        if l:buftype == 'quickfix'
            return '[Quickfix]'
        elseif l:name != ''
            if a:fullname 
                return '-'.fnamemodify(l:name, ':p')
            else
                return '-'.fnamemodify(l:name, ':t')
            endif
        else
        endif
        return '[No Name]'
    endif
endfunc
 
" get a single tab label
function! Vim_NeatTabLabel(n)
    let l:buflist = tabpagebuflist(a:n)
    let l:winnr = tabpagewinnr(a:n)
    let l:bufnr = l:buflist[l:winnr - 1]
    return Vim_NeatBuffer(l:bufnr, 0)
endfunc
 
" setup new tabline, just like %M%t in macvim
set tabline=%!Vim_NeatTabLine()
" set guitablabel=%{Vim_NeatGuiTabLabel()}

" Ag
" Set mapleader
let mapleader = ","
" for easy using sliver search
nmap <leader>f :norm yiw<CR>:Ag! -t -Q "<C-R>""
" Locate and return character "above" current cursor position.
function! LookUpwards()
    let column_num = virtcol('.')
    let target_pattern = '\%' . column_num . 'v.'
    let target_line_num = search(target_pattern . '*\S', 'bnW')


    if !target_line_num
        return ""
    else
        return matchstr(getline(target_line_num), target_pattern)
    endif
endfunction
imap <silent> <C-Y> <C-R><C-R>=LookUpwards()<CR>

" golang
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <leader>w :GoImports<CR>
au FileType go nmap <leader>s <Plug>(go-implements)

" basic
syntax on
syntax enable

set completeopt=longest,menu
set cscopequickfix=s-,c-,d-,i-,t-,e-
set number
set ruler
set tabstop=4
set softtabstop=4
set shiftwidth=4
set ts=4
set expandtab
set cindent
set novisualbell
set laststatus=2
set cinoptions=g0
set hlsearch
set incsearch
set ic

" maxmempattern default 1000
set maxmempattern=10000

nnoremap <space> za

" colorscheme
set t_Co=256
set background=dark
"colorscheme monokai
"colorscheme luna-term
"colorscheme desert
"colorscheme SolarizedDark
colorscheme luna-term

"
"let g:solarized_termcolors=256
"let g:solarized_visibility="high"
"colorscheme solarized

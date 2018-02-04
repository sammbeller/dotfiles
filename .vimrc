" turn off auto comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Allow hidden buffers
set hidden

" Turn on line numbering
set number

" Turn on filetype plugins
filetype plugin on

" Case insensitive search
set ic

" Replace tabs with spaces
set tabstop=2
set shiftwidth=2
set expandtab

" set tag file
set tags=$TRTOP/tags

" start shell in interactive mode, forces load of .bashrc
set shellcmdflag+=i

" set wildmenu
set wildmenu

" key mappings
" open tag in new tab
nnoremap <silent><C-}> <C-w><C-]><C-w>T

syntax on

" Set fold method
set foldmethod=syntax

" pathogen https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" Return to last edit position when opening files (You want this!)
" autocmd BufReadPost *
"      \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
" set viminfo^=%


" Ctrl-P stuff
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}


" Center screen on line
nmap n nzz
nmap N Nzz
nmap G Gzz


" Vimwiki settings
let g:vimwiki_list = [{'path': '/Users/sbeller/Documents/vimwiki'}]

" Tagbar settings
nmap <F8> :TagbarToggle<CR>

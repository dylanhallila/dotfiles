" ------------------------------------------------------------------------------
" .vimrc
" ------------------------------------------------------------------------------

" Disable vi compatibility
set nocompatible

if has("autocmd")
	" Load files for specific filetypes
	filetype on
	filetype indent on
	filetype plugin on

	" Languages with specific tabs/space requirements
	autocmd FileType make setlocal ts=4 sts=4 sw=4 noexpandtab
	" Filetypes
	au BufRead,BufNewFile *.phar set ft=php

	au BufRead,BufNewFile *.json set ts=2 sts=2 sw=2  noexpandtab

	au BufRead,BufNewFile *.feature set ts=2 sts=2 sw=2  noexpandtab
	autocmd FileType json syntax match Comment +\/\/.\+$+
endif

let g:vue_pre_processors = ['scss', 'typescript']

" Change mapleader to ,
let mapleader=","

" COC vim https://github.com/neoclide/coc.nvim
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

if has("syntax")
	if &term =~ '256color'
		" disable Background Color Erase (BCE) so that color schemes
		" render properly when inside 256-color tmux and GNU screen.
		" see also http://snk.tuxfamily.org/log/vim-256color-bce.html
		set t_ut=
	endif

	" Set 256 color terminal support
	set t_Co=256

	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors

	" Enable syntax highlighting
	syntax on
	" Set dark background
	set background=dark

	let g:gruvbox_contrast_dark = 'hard'
	colorscheme gruvbox

	" othewise maps F8
	let g:colorscheme_switcher_define_mappings=0
	nmap <leader>c :echo g:colors_name<CR>
	nmap <leader>rc :RandomColorScheme<CR>
	nmap <leader>nc :NextColorScheme<CR>
	nmap <leader>pc :PreviousColorScheme<CR>



	" Solarized color scheme
	"let g:solarized_termcolors=256
	"colorscheme solarized

	" Molokai color scheme
	"let g:molokai_original = 1
	"let g:rehash256 = 1
	"colorscheme molokai

	" let g:syntastic_debug = 3
	let g:airline_theme = 'onedark'
	" Enable the tab line / buffer list
	let g:airline#extensions#tabline#enabled = 1
	" Only show the file name
	let g:airline#extensions#tabline#fnamemod = ':t'
endif

" {{{ Coc Vim Autocomplete setup
if empty(system('which node')) == 0
	packadd! coc.nvim
	au FileType vue let b:coc_root_patterns = ['.git', '.env', 'package.json', 'tsconfig.json', 'jsconfig.json', 'vite.config.ts', 'nuxt.config.ts']
	" @yaegassy/coc-volar is for vue 3
	let g:coc_global_extensions = [
		\'@yaegassy/coc-volar',
		\'@yaegassy/coc-ansible',
		\'coc-tsserver',
		\'coc-eslint',
		\'coc-stylelintplus',
		\'coc-json',
		\'coc-xml',
		\'coc-highlight',
		\'coc-html',
		\'coc-prettier',
		\'coc-phpls',
		\'coc-prisma',
		\'coc-sh',
		\'coc-yaml',
		\'coc-spell-checker'
	\]


	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
	inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"

	function! s:check_back_space() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" remap for complete to use tab and <cr>
	inoremap <silent><expr> <TAB>
			\ coc#pum#visible() ? coc#pum#next(1):
			\ <SID>check_back_space() ? "\<Tab>" :
			\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Use <c-space> to trigger completion.
	inoremap <silent><expr> <c-space> coc#refresh()

	hi CocSearch ctermfg=12 guifg=#18A3FF
	hi CocMenuSel ctermbg=109 guibg=#13354A

	" Use `[g` and `]g` to navigate diagnostics
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gs :call CocAction('runCommand', 'volar.tsserver.goToSourceDefinition')<CR>
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Open up output channel for debugging an extension
	nmap <silent> <leader>oc :CocCommand workspace.showOutput<CR>

	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
	  if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	  else
		call CocAction('doHover')
	  endif
	endfunction

	" Highlight the symbol and its references when holding the cursor.
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	nmap <leader>f  :call CocAction('runCommand', 'prettier.formatFile')<CR>
	xmap <leader>f  :call CocAction('runCommand', 'prettier.formatFile')<CR>

	" auto format prisma files since prettier one isn't working
	autocmd BufWrite *.prisma call CocAction('format')

	augroup mygroup
	  autocmd!
	  " Setup formatexpr specified filetype(s).
	  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	  " Update signature help on jump placeholder.
	  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current line.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Introduce function text object
	" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
	xmap if <Plug>(coc-funcobj-i)
	xmap af <Plug>(coc-funcobj-a)
	omap if <Plug>(coc-funcobj-i)
	omap af <Plug>(coc-funcobj-a)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocAction('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support.
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline.
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" Mappings using CoCList:
	" Show all diagnostics.
	nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols.
	nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

	nnoremap <leader>i :CocCommand editor.action.organizeImport<CR>
	nnoremap <leader>lf :CocCommand eslint.executeAutofix<CR>

	" Make up/down arrows close the menu
	inoremap <expr> <Up> pumvisible() ? "\<C-y>\<Up>" : "\<Up>"
	inoremap <expr> <Down> pumvisible() ? "\<C-y>\<Down>" : "\<Down>"
	" end coc vim
endif
" }}}

" Ctrlp Fuzzy file search
" {{{
let g:ctrlp_working_path_mode = 'r'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'some_bad_symbolic_links',
	\ }
" }}}

" templates used on new files
augroup templates
	autocmd BufNewFile *.vue 0r ~/.vim/templates/sfc.vue
augroup END

if has("cmdline_info")
	" Show the cursor line and column number
	set ruler
	" Show partial commands in status line
	set showcmd
	" Show whether in insert or replace mode
	set showmode
endif

if has("statusline")
	" Always show status line
	set laststatus=2
endif

if has("wildmenu")
	" Show a list of possible completions
	set wildmenu
	" Tab autocomplete longest possible part of a string, then list
	set wildmode=list:longest,full
endif

if has("extra_search")
	" Highlight searches [use :noh or ctrl+l to clear]
	set hlsearch
	" Highlight dynamically as pattern is typed
	set incsearch
	" Ignore case of searches...
	set ignorecase
	" ...unless has mixed case
	set smartcase
	" Highlight matching brackets
	set showmatch
endif

" Set encoding to utf-8
set encoding=utf-8
" Reload files changed outside vim
set autoread
" Show the filename in the window titlebar
set title
" Allows buffers to be hidden if you've modified a buffer.
set hidden
" http://vim.wikia.com/wiki/Modeline_magic
set modeline
" Store lots of command history default is 20
set history=2000
" Line numbers are good
set number
" Scroll when 5 lines from top/bottom
set scrolloff=5
" Fold on markers
set foldmethod=marker
" Don't set cursor at start of line when moving
set nostartofline
" Turn on lazy redraw
set lazyredraw
" Highlight current line
set cursorline

" Show 'invisible' characters
set list
" Set characters used to indicate 'invisible' characters
set list listchars=tab:>-,trail:-,nbsp:_

" Indentation
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" Open vertical split below
set splitbelow
" Open horizontal split to the right
set splitright

" Backups, swaps and persistent undo history
set backupdir=~/.vim/backups  " where to save backups
set directory=~/.vim/swaps    " where to save swaps
set undodir=~/.vim/undo       " where to save undo history
set undofile                  " save undo's after file closes
set undolevels=1000           " how many undos
set undoreload=10000          " number of lines to save for undo

" Disable beep and flash
set noeb vb t_vb=
au GUIEnter * set vb t_vb=

" Make selection again after a multi-line indent
vnoremap < <gv
vnoremap > >gv

" Toggle folds with space bar
nnoremap <Space> za

" Better page up/down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

" Move to the next buffer
nmap <leader>l :bnext<CR>
" Move to previous buffer
nmap <leader>h :bprev<CR>
" To open a new empty buffer
nmap <leader>o :enew<cr>
" Close the current buffer and move to the previous one
nmap <leader>x :bp <BAR> bd #<CR>

" <F2> grep php files
map <F2> :vimgrep /stext/ **/*.php \| :copen

" <F8> toggles 'copy/paste mode'
map <F8> :exe "set invpaste invnumber invlist signcolumn=" .. (&signcolumn == "yes" ? "no" : "yes")<C-M>

" <F9> <F10> toggles vertcal line at column 80
map <F9> :set textwidth=80 colorcolumn=+1<C-M>
map <F10> :set textwidth=0 colorcolumn=0<C-M>

" <F12> forgot to open with sudo? no problem
map <F12> :w !sudo tee > /dev/null %<C-M>

" <C-l> remove highlighting after a search
nnoremap <C-l> :nohl<CR>

" Remap some common misspellings (bad habbits)
command W w
command Q q
command Wq wq
command WQ wq
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

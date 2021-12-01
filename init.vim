" Basic Configuration
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent

let mapleader=","
filetype plugin on

" Tab
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tn :+tabnext<cr>
nnoremap <leader>tp :-tabnext<cr>
nnoremap <leader>ts :1tabnext<cr>
nnoremap <leader>te :$tabnext<cr>

" Auto install vim plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd!
    autocmd VimEnter * PlugInstall
endif

" Plugins
call plug#begin()

Plug 'vim-airline/vim-airline'

Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'StanAngeloff/php.vim'
Plug 'stephpy/vim-php-cs-fixer'

Plug 'jiangmiao/auto-pairs'

Plug 'neovim/nvim-lspconfig'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-path'
Plug 'phpactor/phpactor' ,  {'do': 'composer install', 'for': 'php'}
Plug 'phpactor/ncm2-phpactor'

Plug 'dense-analysis/ale'

Plug 'morhetz/gruvbox'

Plug 'Pocco81/AutoSave.nvim'

Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'tpope/vim-fugitive'

call plug#end()

set nu
set background=dark
colorscheme gruvbox

" NERDTree Configuration
nnoremap <leader>ntf :NERDTreeFocus<CR>
nnoremap <leader>ntt :NERDTreeToggle<CR>
" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif


" Vim PHP cs fixer Configuration
let g:php_cs_fixer_path = "~/.config/composer/vendor/bin/php-cs-fixer" " define the path to the php-cs-fixer.phar

" If you use php-cs-fixer version 2.x
let g:php_cs_fixer_rules = "@PSR12"          " options: --rules (default:@PSR2)
"let g:php_cs_fixer_cache = ".php_cs.cache" " options: --cache-file
"let g:php_cs_fixer_config_file = '.php_cs' " options: --config
" End of php-cs-fixer version 2 config params

let g:php_cs_fixer_php_path = "php"               " Path to PHP
let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0

nnoremap <silent><leader>pcd :call PhpCsFixerFixDirectory()<CR>
nnoremap <silent><leader>pcf :call PhpCsFixerFixFile()<CR>
autocmd BufWritePost *.php silent! call PhpCsFixerFixFile()


" NERDCommenter Configuration
nnoremap ,ct :call nerdcommenter#Comment(0,"toggle")<CR>


" Ale Configuration

" phpactor and ncm2 Configuration
lua require'lspconfig'.phpactor.setup{}
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nmap <Leader>u :call phpactor#UseAdd()<CR>
nmap <leader>nn :call phpactor#Navigate()<CR>
nmap <leader>o :call phpactor#GotoDefinition()<CR>

" Autosave Configuration
lua << EOF
local autosave = require("autosave")

autosave.setup(
    {
        enabled = true,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)
EOF

" ALE (code linter)
let g:ale_linters = {'php': ['php', 'phpstan', 'phpmd']}
let g:ale_php_phpstan_executable = '.config/composer/vendor/bin/phpstan'
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'php': ['phpcbf', 'php_cs_fixer', 'remove_trailing_lines', 'trim_whitespace'],
  \}
let g:ale_fix_on_save = 1

" Fzf
nnoremap <leader>ff :Files<cr>

" Fix for Windows
scriptencoding utf-8
set encoding=utf-8

let g:python3_host_prog = expand('~/.venvs/neovim/Scripts/python.exe')

" Shell configuration for Windows
if has('win32')
    set shell=pwsh
    set shellcmdflag=-Command
else
    set shell=sh
endif

call plug#begin('~/.config/nvim/plugged')

" Interface improvements
Plug 'nvim-tree/nvim-web-devicons'     " Icons
Plug 'akinsho/bufferline.nvim'         " Buffer tabs
Plug 'nvim-lualine/lualine.nvim'       " Status line
Plug 'preservim/nerdtree'              " Classic file manager

" Themes
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }  " Dark one
Plug 'folke/tokyonight.nvim'           " Purple-blue
Plug 'rebelot/kanagawa.nvim'           " Calm Japanese
Plug 'EdenEast/nightfox.nvim'          " Green-blue
Plug 'navarasu/onedark.nvim'           " One Dark

" Syntax and highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Enhanced highlighting
Plug 'sheerun/vim-polyglot'            " Language support

" Autocompletion and LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Autocompletion
Plug 'williamboman/mason.nvim'         " LSP server manager
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'           " LSP configuration

" Search and navigation
Plug 'nvim-lua/plenary.nvim'           " Dependency for Telescope
Plug 'nvim-telescope/telescope.nvim'   " Super search

" Editing
Plug 'tpope/vim-surround'              " Working with surroundings
Plug 'windwp/nvim-autopairs'           " Auto-closing brackets

" Productivity
Plug 'lewis6991/gitsigns.nvim'         " Git icons
Plug 'tpope/vim-fugitive'              " Git integration
Plug 'folke/which-key.nvim'            " Hotkey hints

call plug#end()

" Basic settings
set mouse=a                            " Enable mouse
set number                             " Line numbers
set smarttab                           " Smart tab placement
set tabstop=4                          " What one tab equals
set shiftwidth=4                       " Number of spaces for indentation
set softtabstop=4                      " Same as tabstop, but in insert mode
set expandtab                          " Replace tabs with spaces
set autoindent                         " Automatic indentation
syntax on                              " Syntax highlighting
set termguicolors                      " Enable true colors

" Color scheme
colorscheme carbonfox
" colorscheme tokyonight-night
" colorscheme catppuccin
" colorscheme kanagawa
" colorscheme onedark

" Hotkeys for search
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" NERDTree file tree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Buffer management
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>bd :bd<CR>

" Git
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>

" Lua configurations
lua << EOF
-- Status line
require('lualine').setup({
  options = { theme = 'auto' }  -- Will automatically pick up your theme
})

-- Syntax tree
require('nvim-treesitter.configs').setup({
  ensure_installed = {"lua", "python", "javascript", "typescript", "json", "c", "cpp", "java"},
  highlight = { enable = true },
})

-- Auto-closing brackets
require('nvim-autopairs').setup({})

-- Buffer line
require('bufferline').setup({})

-- Git signs
require('gitsigns').setup({})

-- Which-key
require('which-key').setup({})

-- Mason (LSP manager)
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {}  -- Add needed LSP servers
})
EOF

function! HexDump()
    if empty(expand('%')) || !filereadable(expand('%'))
        echohl Error | echo "Save the file to disk!" | echohl None
        return
    endif

    let l:old_shell = &shell
    let l:old_shellcmdflag = &shellcmdflag
    let l:old_shellxquote = &shellxquote

    set shell=cmd.exe
    set shellcmdflag=/c
    set shellxquote=

    let l:xxd = 'C:\Program Files\Neovim\bin\xxd.exe'
    let l:file = expand('%:p')

    let l:inner_cmd = '"' . l:xxd . '" "' . l:file . '"'
    let l:cmd = '"' . l:inner_cmd . '"'

    let l:output = system(l:cmd)

    let &shell = l:old_shell
    let &shellcmdflag = l:old_shellcmdflag
    let &shellxquote = l:old_shellxquote

    if v:shell_error
        echohl Error
        echo "Final command: " . l:cmd
        echo "Error (code " . v:shell_error . "):"
        echo l:output
        echohl None
        return
    endif

    tabnew
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    setlocal filetype=xxd
    call setline(1, split(l:output, "\n"))
    nnoremap <buffer> q :q<CR>
endfunction

command! Hex call HexDump()

" Switch to editable hex mode
command! HexEdit call s:HexEditToggle(1)

" Return to binary mode
command! HexSave call s:HexEditToggle(0)

function! s:HexEditToggle(to_hex)
    let l:xxd = 'C:\Program Files\Git\usr\bin\xxd.exe'

    let l:old_shell = &shell
    let l:old_shellcmdflag = &shellcmdflag
    let l:old_shellxquote = &shellxquote

    set shell=cmd.exe
    set shellcmdflag=/c
    set shellxquote=

    if a:to_hex
        " Convert current buffer to hex
        let l:cmd = '"' . l:xxd . '"'
    else
        " Convert hex buffer back to binary
        let l:cmd = '"' . l:xxd . '" -r'
    endif

    " Apply filter to current buffer
    execute '%!' . l:cmd

    " Restore settings
    let &shell = l:old_shell
    let &shellcmdflag = l:old_shellcmdflag
    let &shellxquote = l:old_shellxquote

    if v:shell_error
        echohl Error | echo "Error during conversion via xxd" | echohl None
        return
    endif

    if a:to_hex
        setlocal filetype=xxd
        echo "Hex editing mode enabled. After changes execute :HexSave"
    else
        echo "File converted back to binary format. Execute :w to save."
    endif
endfunction

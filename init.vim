" Fix для Windows
scriptencoding utf-8
set encoding=utf-8

let g:python3_host_prog = expand('~/.venvs/neovim/Scripts/python.exe')

" Настройка оболочки для Windows
if has('win32')
    set shell=pwsh
    set shellcmdflag=-Command
else
    set shell=sh
endif

call plug#begin('~/.config/nvim/plugged')

" Улучшение интерфейса
Plug 'nvim-tree/nvim-web-devicons'     " Иконки
Plug 'akinsho/bufferline.nvim'         " Вкладки буферов
Plug 'nvim-lualine/lualine.nvim'       " Статусная строка
Plug 'preservim/nerdtree'              " Классический файловый менеджер

" Темы (оставьте только 1-2 любимые)
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }  " Стильная тема
Plug 'folke/tokyonight.nvim'           " Фиолетово-синяя
Plug 'rebelot/kanagawa.nvim'           " Спокойная японская
Plug 'EdenEast/nightfox.nvim'          " Зелёно-синяя
Plug 'navarasu/onedark.nvim'           " One Dark (как в VS Code)

" Синтаксис и подсветка
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " Улучшенная подсветка
Plug 'sheerun/vim-polyglot'            " Поддержка языков

" Автодополнение и LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Автодополнение
Plug 'williamboman/mason.nvim'         " Менеджер LSP серверов
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'           " Конфигурация LSP

" Поиск и навигация
Plug 'nvim-lua/plenary.nvim'           " Зависимость для Telescope
Plug 'nvim-telescope/telescope.nvim'   " Супер-поиск

" Редактирование
Plug 'tpope/vim-surround'              " Работа с окружением
Plug 'windwp/nvim-autopairs'           " Автозакрытие скобок

" Производительность
Plug 'lewis6991/gitsigns.nvim'         " Git значки
Plug 'tpope/vim-fugitive'              " Git интеграция
Plug 'folke/which-key.nvim'            " Подсказки горячих клавиш

call plug#end()

" Основные настройки
set mouse=a                            " Подключаем мышку
set number                             " Нумерация строк
set smarttab                           " Умные проставления табов 
set tabstop=4                          " Чему равен один таб
set shiftwidth=4                       " Количество пробелов для отступов
set softtabstop=4                      " То же, что и tabstop, но в режиме вставки
set expandtab                          " Замена табов на пробелы
set autoindent                         " Автоматический отступ
syntax on                              " Подсветка
set termguicolors                      " Подключаем топ цвета

" Цветовая схема
colorscheme carbonfox
" colorscheme tokyonight-night
" colorscheme catppuccin
" colorscheme kanagawa
" colorscheme onedark

" Горячие клавиши для поиска
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Файловое дерево NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Управление буферами
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>bd :bd<CR>

" Git
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>

" Lua конфигурации
lua << EOF
-- Статусная строка
require('lualine').setup({
  options = { theme = 'auto' }  -- Автоматически подхватит вашу тему
})

-- Дерево синтаксиса
require('nvim-treesitter.configs').setup({
  ensure_installed = {"lua", "python", "javascript", "typescript", "json", "c", "cpp", "java"},
  highlight = { enable = true },
})

-- Автозакрытие скобок
require('nvim-autopairs').setup({})

-- Буферная линия
require('bufferline').setup({})

-- Git знаки
require('gitsigns').setup({})

-- Which-key
require('which-key').setup({})

-- Mason (LSP менеджер)
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {}  -- Добавьте нужные LSP серверы
})
EOF

function! HexDump()
    if empty(expand('%')) || !filereadable(expand('%'))
        echohl Error | echo "Сохраните файл на диск!" | echohl None
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
        echo "Финальная команда: " . l:cmd
        echo "Ошибка (код " . v:shell_error . "):"
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

" Переключиться в редактируемый hex-режим
command! HexEdit call s:HexEditToggle(1)

" Вернуться в бинарный режим
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
        " Конвертируем текущий буфер в hex
        let l:cmd = '"' . l:xxd . '"'
    else
        " Конвертируем hex-буфер обратно в бинарный
        let l:cmd = '"' . l:xxd . '" -r'
    endif

    " Применяем фильтр к текущему буферу
    execute '%!' . l:cmd

    " Восстанавливаем настройки
    let &shell = l:old_shell
    let &shellcmdflag = l:old_shellcmdflag
    let &shellxquote = l:old_shellxquote

    if v:shell_error
        echohl Error | echo "Ошибка при конвертации через xxd" | echohl None
        return
    endif

    if a:to_hex
        setlocal filetype=xxd
        echo "Режим hex-редактирования включён. После изменений выполнить :HexSave"
    else
        echo "Файл преобразован обратно в бинарный формат. Выполнить :w для сохранения."
    endif
endfunction

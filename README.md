# nvim-config

My nvim config. This config only for windows, i have made some fixes for windows, but may be it will be work in Linux or macOS, just delete some windows features.

## Commands

| Command | What does |
|---------|-----------|
| \<leader\>ff | Find files |
| \<leader\>fg | Find text in files |
| \<leader\>fb | Switch buffers over |
| \<leader\>fh| Help |
| \<leader\>n | Focus on tree |
| \<C-n\> | Open tree |
| \<C-t\> | Switch tree over |
| \<C-f\> | Find current file |
| \<Tab\> | Next buffer |
| \<S-Tab\> | Previous buffer |
| \<leader\>bd | Close buffer |
| \<leader\>gs | Git status |
| \<leader\>gb | Git blame |
| :Hex | Viewing hex-dump |
| :HexEdit | Edit hex |
| :HexSave | Save hex |

## How to change theme

Find line with color schemes and uncomment theme you want to use:

```vim
" Цветовая схема
" colorscheme carbonfox
" colorscheme tokyonight-night
" colorscheme catppuccin
" colorscheme kanagawa
" colorscheme onedark
```


## Quick start

Install nvim. Then do this:

```bash
mkdir ~/AppData/Local/nvim
```

- Copy this config to ~/AppData/Local/nvim/init.vim
- Bash:

```bash
nvim
```

- Inside nvim:

```nvim
:PlugInstall
```

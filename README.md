# nvim-config

My nvim config. This config only for windows, i have made some fixes for windows, but may be it will be work in Linux or macOS, just delete some windows features.

## Commands

| Command | What does |
|---------|-----------|
| \<leader\>ff | Find files |
| \<leader\>fg | Find text in files |
| \<leader\>fb | switch buffers over |
| \<leader\>fh| help |
| \<leader\>n | Focus on tree |
| \<C-n\> | Open tree |
| \<C-t\> | switch tree over |
| \<C-f\> | find current file |
| \<Tab\> | Next buffer |
| \<S-Tab\> | Previous buffer |
| \<leader\>bd | Close buffer |
| \<leader\>gs | Git status |
| \<leader\>gb | Git blame |
| :Hex | Viewing hex-dump |
| :HexEdit | Edit hex |
| :HexSave | Save hex |



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

- In nvim:

```nvim
:PlugInstall
```

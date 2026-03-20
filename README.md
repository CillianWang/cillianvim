# Neovim Setup

This is a portable [LazyVim](https://github.com/LazyVim/LazyVim) setup meant for:

- split windows and split terminals
- jump to definition with LSP
- fast file switching
- keeping the whole config in git for other devices

## Installed Location

This config lives in `~/.config/nvim`.

Your previous config was backed up to:

`~/.config/nvim.backup-20260319`

## Daily Use

Open Neovim:

```bash
nvim
```

Open a file:

```bash
nvim path/to/file
```

## Most Useful Keys

Leader key in LazyVim is `Space`.

- `Space Space`: find files
- `Space /`: grep text in project
- `Space ,`: switch buffers
- `gd`: jump to definition
- `gr`: list references
- `K`: show hover docs
- `Space e`: file explorer

### Splits

- `Space s v`: vertical split
- `Space s h`: horizontal split
- `Space s e`: equalize split sizes
- `Space s x`: close current split
- `Ctrl-h/j/k/l`: move between splits

### Terminal

- `Space t v`: open terminal in vertical split
- `Space t h`: open terminal in horizontal split
- `Esc Esc`: leave terminal mode

## First Steps To Learn

1. Open a project with `nvim .`
2. Press `Space Space` and open a file
3. Move with `h j k l`
4. Press `Space s v` to split the window
5. Press `Space t h` to open a terminal below
6. Use `Ctrl-h/j/k/l` to move between editor and terminal
7. Put cursor on a function name and press `gd`

## Git For Other Devices

Right now this directory is a git clone of the LazyVim starter. To make it your own:

```bash
cd ~/.config/nvim
git remote rename origin upstream
git remote add origin git@github.com:YOUR_NAME/nvim-config.git
git add .
git commit -m "My Neovim setup"
git push -u origin main
```

On another device:

```bash
git clone git@github.com:YOUR_NAME/nvim-config.git ~/.config/nvim
nvim
```

The first launch will install plugins automatically.

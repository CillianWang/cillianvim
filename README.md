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

The config is synced to [CillianWang/cillianvim](https://github.com/CillianWang/cillianvim)
on the `main` branch.

To download config updates when your working tree is clean:

```bash
cd ~/.config/nvim
git pull --ff-only
```

On another device, clone into an empty config location:

```bash
git clone https://github.com/CillianWang/cillianvim.git ~/.config/nvim
nvim
```

The first launch will install plugins automatically. Run `:Lazy restore` to
match the plugin versions recorded in `lazy-lock.json`.

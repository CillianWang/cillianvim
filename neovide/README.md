# Neovide config

A snapshot of my [Neovide](https://neovide.dev) GUI config. The live copy lives
at `~/.config/neovide/`; this folder is a backup kept alongside the Neovim
config so everything is in one repo.

## Install

```sh
mkdir -p ~/.config/neovide
cp config.toml ~/.config/neovide/config.toml
cp icon.png    ~/.config/neovide/icon.png
```

(Or symlink `~/.config/neovide` → this folder to keep them in sync.)

## Machine-specific paths in `config.toml`

These are hard-coded for my machine (Apple Silicon mac, user `pingy`). **Change
them when moving to another machine:**

| Key          | Value                              | What to check |
|--------------|------------------------------------|---------------|
| `neovim-bin` | `/opt/homebrew/bin/nvim`           | Output of `which nvim` (Intel macs use `/usr/local/bin/nvim`). Needed because GUI launches from Finder/Spotlight don't inherit your shell `PATH`. |
| `icon`       | `/Users/pingy/.config/neovide/icon.png` | Update the home-directory portion to your own user. |
| `chdir`      | `/Users/pingy/code`                | The directory Neovide opens in at startup. Point it at your own projects dir. |

Other settings (`frame = "none"`, etc.) are portable.

## Notes

- The custom app icon (`icon.png`) is set two ways: `icon` in `config.toml`
  (read on terminal launches) and the `NEOVIDE_ICON` env var (read on
  Spotlight/Finder launches). The env var is set via `launchctl setenv` and
  does **not** survive a reboot — make it permanent with a LaunchAgent if
  desired.
- Most look-and-feel settings (font, padding, line-spacing, Cmd-key clipboard
  bindings) live in the **Neovim** config under `lua/config/options.lua`, gated
  behind `if vim.g.neovide`, because Neovide reads them as GUI vim options
  rather than from `config.toml`.

-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor",
  "i-ci-ve:ver35-Cursor",
  "r-cr-o:hor20-Cursor",
}

-- Some terminals need explicit escape codes to render italics.
vim.cmd([[let &t_ZH = "\e[3m"]])
vim.cmd([[let &t_ZR = "\e[23m"]])

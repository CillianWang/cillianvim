-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

vim.opt.cmdheight = 0

-- Absolute line numbers only (no relativenumber)
vim.opt.number = true
vim.opt.relativenumber = false

-- Diff filler: LazyVim defaults to "╱" (diagonal slashes). Use plain space
-- so the filler is just a background color instead of striped characters.
vim.opt.fillchars:append({ diff = " " })

-- Disable LazyVim's trouble breadcrumb (we add our own clean version in lualine opts)
vim.g.trouble_lualine = false

vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor",
  "i-ci-ve:ver35-Cursor",
  "r-cr-o:hor20-Cursor",
}

-- Some terminals need explicit escape codes to render italics.
vim.cmd([[let &t_ZH = "\e[3m"]])
vim.cmd([[let &t_ZR = "\e[23m"]])

if vim.g.neovide then
  -- GUI launches (Spotlight/Finder) often inherit a minimal PATH, so make
  -- sure Homebrew tools (lazygit, fzf, rg, …) and ~/.local/bin (node symlink,
  -- used by markdown-preview.nvim) are reachable from nvim. Prepend each dir
  -- that isn't already present (checked individually — a partial PATH that
  -- has homebrew but not ~/.local/bin must still get ~/.local/bin added).
  local want = {
    "/opt/homebrew/bin",
    "/opt/homebrew/sbin",
    "/usr/local/bin",
    vim.fn.expand("~/.local/bin"),
  }
  local path = vim.env.PATH or ""
  local prefix = {}
  for _, dir in ipairs(want) do
    -- match dir as a whole PATH entry (bounded by ":"); plain (literal) find
    if not (":" .. path .. ":"):find(":" .. dir .. ":", 1, true) then
      table.insert(prefix, dir)
    end
  end
  if #prefix > 0 then
    vim.env.PATH = table.concat(prefix, ":") .. ":" .. path
  end

  vim.o.guifont = "CascadiaSarasa,Cascadia Code NF:h16"
  vim.opt.linespace = 4

  -- Window padding (set at runtime via vim globals, not config.toml)
  vim.g.neovide_padding_top = 40
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_left = 40
  vim.g.neovide_padding_right = 40

  -- Enable the Cmd key (the "logo" key) on macOS so we can bind <D-…> mappings.
  vim.g.neovide_input_use_logo = true

  -- Cmd+C / Cmd+V / Cmd+X / Cmd+A / Cmd+Z — use the system clipboard register "+
  local map = vim.keymap.set
  map({ "n", "v" }, "<D-c>", '"+y', { desc = "Copy to system clipboard" })
  map({ "n", "v" }, "<D-x>", '"+d', { desc = "Cut to system clipboard" })
  map({ "n", "v" }, "<D-v>", '"+P', { desc = "Paste from system clipboard" })
  map("i", "<D-v>", "<C-r>+", { desc = "Paste from system clipboard" })
  map("c", "<D-v>", "<C-r>+", { desc = "Paste from system clipboard" })
  map("t", "<D-v>", [[<C-\><C-n>"+Pi]], { desc = "Paste from system clipboard" })
  map("n", "<D-a>", "ggVG", { desc = "Select all" })
  map({ "n", "i" }, "<D-z>", "<cmd>undo<cr>", { desc = "Undo" })
  map({ "n", "i" }, "<D-S-z>", "<cmd>redo<cr>", { desc = "Redo" })
end

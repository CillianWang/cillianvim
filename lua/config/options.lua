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

-- Default tabline labels a tab by its *current* window's buffer, so focusing
-- the CodeCompanion chat float renames the tab to "[CodeCompanion] N". Label
-- each tab by its first normal (non-floating) window instead.
local function tab_label(tab)
  -- Pick the main window of the tab: the largest non-floating one, so side
  -- panels (e.g. the snacks explorer layout box) don't name the tab.
  local best, best_area = nil, -1
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
    local cfg = vim.api.nvim_win_get_config(win)
    if cfg.relative == "" then
      local area = vim.api.nvim_win_get_width(win) * vim.api.nvim_win_get_height(win)
      if area > best_area then
        best, best_area = win, area
      end
    end
  end
  if best then
    local buf = vim.api.nvim_win_get_buf(best)
    local name = vim.fn.bufname(buf)
    name = name ~= "" and vim.fn.fnamemodify(name, ":t") or "[No Name]"
    if vim.bo[buf].modified then
      name = name .. "+"
    end
    return name
  end
  return "[No Name]"
end

function _G.user_tabline()
  local parts = {}
  local current = vim.api.nvim_get_current_tabpage()
  for index, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local hl = tab == current and "%#TabLineSel#" or "%#TabLine#"
    parts[#parts + 1] = hl .. " " .. index .. ":" .. tab_label(tab) .. " "
  end
  parts[#parts + 1] = "%#TabLineFill#%T"
  return table.concat(parts)
end

vim.o.tabline = "%!v:lua.user_tabline()"

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

  -- IosevkaTerm NFM: Latin + Nerd Font icons. CascadiaSarasa stays in the
  -- chain because Iosevka has NO CJK glyphs — without a CJK-capable fallback,
  -- every Chinese character triggers a full system font-database scan, which
  -- makes scrolling/editing Chinese text stutter badly in Neovide.
  vim.o.guifont = "IosevkaTerm NFM,CascadiaSarasa:h16"
  vim.opt.linespace = 4

  -- Snappier GUI feel. Defaults (cursor 0.13s, scroll 0.3s) can feel like
  -- input lag; shorten both. Set either to 0 to disable the animation.
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_scroll_animation_length = 0.1

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

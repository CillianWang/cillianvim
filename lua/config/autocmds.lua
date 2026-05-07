-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_wrap_spell")

local diag_cfg = { virtual_text = false, signs = false, underline = false }

vim.schedule(function()
  vim.diagnostic.config(diag_cfg)
end)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.schedule(function()
      vim.diagnostic.config(diag_cfg)
    end)
  end,
})

local augroup = vim.api.nvim_create_augroup("user_startup_explorer", { clear = true })

vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "VeryLazy",
  callback = function()
    vim.schedule(function()
      local args = vim.fn.argv()
      local argc = vim.fn.argc()

      if argc == 0 then
        Snacks.explorer({ cwd = LazyVim.root() })
        return
      end

      if argc == 1 then
        local target = vim.fn.fnamemodify(args[1], ":p")
        if vim.fn.isdirectory(target) == 1 then
          vim.cmd.cd(target)
          Snacks.explorer({ cwd = target })
          return
        end

        Snacks.explorer.reveal({ cwd = LazyVim.root() })
      end
    end)
  end,
})

local ui_augroup = vim.api.nvim_create_augroup("user_ui_tweaks", { clear = true })

local function hl_resolved(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
  if ok and hl and next(hl) ~= nil then
    return hl
  end
  ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = fallback, link = false })
  if ok and hl and next(hl) ~= nil then
    return hl
  end
  return {}
end

local function apply_ui_tweaks()
  local linernr_fg = vim.api.nvim_get_hl(0, { name = "LineNr", link = false }).fg
  vim.api.nvim_set_hl(0, "LineNrAbove", { fg = linernr_fg, italic = true })
  vim.api.nvim_set_hl(0, "LineNrBelow", { fg = linernr_fg, italic = true })
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = ui_augroup,
  callback = function()
    vim.schedule(function()
      vim.defer_fn(apply_ui_tweaks, 100)
    end)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = ui_augroup,
  pattern = "VeryLazy",
  callback = function()
    vim.schedule(function()
      vim.defer_fn(apply_ui_tweaks, 100)
    end)
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  group = ui_augroup,
  callback = function()
    vim.schedule(function()
      vim.defer_fn(apply_ui_tweaks, 100)
    end)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  pattern = "murphy",
  callback = function()
    local hi = vim.api.nvim_set_hl
    local colors = {
      fg = "#e8e4d8",
      bg = "#121212",
      bg_alt = "#1a1a1a",
      muted = "#5f5f5f",
      accent = "#87af5f",
      accent2 = "#d7af5f",
      red = "#d75f5f",
      blue = "#5f87af",
      split = "#303030",
    }

    hi(0, "NormalFloat", { fg = colors.fg, bg = colors.bg_alt })
    hi(0, "FloatBorder", { fg = colors.split, bg = colors.bg_alt })
    hi(0, "FloatTitle", { fg = colors.accent, bg = colors.bg_alt, bold = true })
    hi(0, "CursorLineNr", { fg = colors.accent2, bg = colors.bg, bold = true })
    hi(0, "WinSeparator", { fg = colors.split, bg = colors.bg })
    hi(0, "VertSplit", { fg = colors.split, bg = colors.bg })
    hi(0, "Pmenu", { fg = colors.fg, bg = colors.bg_alt })
    hi(0, "PmenuSel", { fg = colors.bg, bg = colors.accent2, bold = true })
    hi(0, "Search", { fg = colors.bg, bg = colors.accent2 })
    hi(0, "IncSearch", { fg = colors.bg, bg = colors.accent, bold = true })
    hi(0, "CurSearch", { fg = colors.bg, bg = colors.accent, bold = true })
    hi(0, "DiagnosticInfo", { fg = colors.blue })
    hi(0, "DiagnosticHint", { fg = colors.accent })
    hi(0, "DiagnosticWarn", { fg = colors.accent2 })
    hi(0, "DiagnosticError", { fg = colors.red })
    hi(0, "Title", { fg = colors.accent2, bold = true })
    hi(0, "Special", { fg = colors.blue })
    hi(0, "SnacksTitle", { fg = colors.accent2, bg = colors.bg_alt, bold = true })
    hi(0, "SnacksInputTitle", { fg = colors.accent2, bg = colors.bg_alt, bold = true })
    hi(0, "SnacksDashboardHeader", { fg = colors.accent2, bold = true })
    hi(0, "SnacksDashboardDesc", { fg = colors.fg })
    hi(0, "SnacksDashboardIcon", { fg = colors.accent })
    hi(0, "SnacksDashboardKey", { fg = colors.blue, bold = true })
  end,
})

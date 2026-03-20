-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.o.background = "dark"

local p = {
  bg = "#15141b",
  bg_cursorline = "#1a1822",
  bg_alt = "#1f1d28",
  bg_code = "#2a2736",
  bg_visual = "#29263c",
  fg = "#edecee",
  fg_muted = "#9b9b9b",
  fg_dim = "#6b6b6b",
  black = "#110f18",
  red = "#ff6767",
  green = "#61ffca",
  yellow = "#ffca85",
  purple = "#a277ff",
  split = "#3d3a4f",
}

local function hi(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

hi("Normal", { fg = p.fg, bg = p.bg })
hi("NormalNC", { fg = p.fg, bg = p.bg })
hi("NormalFloat", { fg = p.fg, bg = p.bg_alt })
hi("FloatBorder", { fg = p.split, bg = p.bg_alt })
hi("FloatTitle", { fg = p.purple, bg = p.bg_alt, bold = true })
hi("Cursor", { fg = p.bg, bg = p.purple })
hi("CursorLine", { bg = p.bg_cursorline })
hi("CursorColumn", { bg = p.bg_cursorline })
hi("ColorColumn", { bg = p.bg_alt })
hi("LineNr", { fg = p.fg_dim, bg = p.bg })
hi("CursorLineNr", { fg = p.purple, bg = p.bg_cursorline, bold = true })
hi("SignColumn", { fg = p.fg_dim, bg = p.bg })
hi("CursorLineSign", { fg = p.fg_dim, bg = p.bg_cursorline })
hi("VertSplit", { fg = p.split, bg = p.bg })
hi("WinSeparator", { fg = p.split, bg = p.bg })
hi("StatusLine", { fg = p.fg, bg = p.bg_visual })
hi("StatusLineNC", { fg = p.fg_dim, bg = p.bg_alt })
hi("TabLine", { fg = p.fg_dim, bg = p.bg })
hi("TabLineFill", { bg = p.bg })
hi("TabLineSel", { fg = p.fg, bg = p.bg_visual, bold = true })
hi("Visual", { bg = p.bg_visual })
hi("Search", { fg = p.bg, bg = p.yellow })
hi("IncSearch", { fg = p.bg, bg = p.purple, bold = true })
hi("CurSearch", { fg = p.bg, bg = p.purple, bold = true })
hi("MatchParen", { fg = p.purple, bold = true })
hi("Pmenu", { fg = p.fg, bg = p.bg_alt })
hi("PmenuSel", { fg = p.bg, bg = p.purple, bold = true })
hi("PmenuSbar", { bg = p.bg_visual })
hi("PmenuThumb", { bg = p.split })
hi("Folded", { fg = p.fg_muted, bg = p.bg_alt })
hi("Directory", { fg = p.purple, bold = true })
hi("Title", { fg = p.purple, bold = true })
hi("ErrorMsg", { fg = p.red, bg = p.bg })
hi("WarningMsg", { fg = p.yellow, bg = p.bg })
hi("MoreMsg", { fg = p.green, bg = p.bg })
hi("ModeMsg", { fg = p.purple, bg = p.bg, bold = true })
hi("Question", { fg = p.green, bg = p.bg })

hi("Comment", { fg = p.fg_dim, italic = true })
hi("Constant", { fg = p.yellow })
hi("String", { fg = p.green })
hi("Character", { fg = p.green })
hi("Number", { fg = p.yellow })
hi("Boolean", { fg = p.yellow, bold = true })
hi("Float", { fg = p.yellow })
hi("Identifier", { fg = p.fg })
hi("Function", { fg = p.purple, bold = true })
hi("Statement", { fg = p.red })
hi("Conditional", { fg = p.red })
hi("Repeat", { fg = p.red })
hi("Label", { fg = p.red })
hi("Operator", { fg = p.fg })
hi("Keyword", { fg = p.red, italic = true })
hi("Exception", { fg = p.red })
hi("PreProc", { fg = p.yellow })
hi("Include", { fg = p.red })
hi("Define", { fg = p.red })
hi("Macro", { fg = p.yellow })
hi("Type", { fg = p.yellow })
hi("StorageClass", { fg = p.yellow })
hi("Structure", { fg = p.yellow })
hi("Typedef", { fg = p.yellow })
hi("Special", { fg = p.purple })
hi("Delimiter", { fg = p.fg_muted })
hi("@module", { fg = p.purple })
hi("@property", { fg = p.yellow })
hi("@variable", { fg = p.fg })
hi("@variable.builtin", { fg = p.purple, italic = true })
hi("@variable.parameter", { fg = p.yellow, italic = true })
hi("@variable.member", { fg = p.green })
hi("@lsp.type.namespace.python", { link = "@module" })
hi("@lsp.type.parameter.python", { link = "@variable.parameter" })
hi("@lsp.type.variable.python", { link = "@variable" })
hi("@lsp.typemod.variable.globalScope.python", { fg = p.yellow })
hi("@lsp.typemod.variable.fileScope.python", { fg = p.fg })
hi("@lsp.typemod.variable.classScope.python", { fg = p.green })
hi("@lsp.typemod.variable.readonly.python", { fg = p.yellow, bold = true })

hi("DiagnosticError", { fg = p.red })
hi("DiagnosticWarn", { fg = p.yellow })
hi("DiagnosticInfo", { fg = p.purple })
hi("DiagnosticHint", { fg = p.green })
hi("DiagnosticVirtualTextError", { fg = p.red, bg = p.bg_alt })
hi("DiagnosticVirtualTextWarn", { fg = p.yellow, bg = p.bg_alt })
hi("DiagnosticVirtualTextInfo", { fg = p.purple, bg = p.bg_alt })
hi("DiagnosticVirtualTextHint", { fg = p.green, bg = p.bg_alt })
hi("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = p.purple })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = p.green })

hi("DiffAdd", { fg = p.green, bg = p.bg_alt })
hi("DiffChange", { fg = p.yellow, bg = p.bg_alt })
hi("DiffDelete", { fg = p.red, bg = p.bg_alt })
hi("DiffText", { fg = p.purple, bg = p.bg_visual })

hi("GitSignsAdd", { fg = p.green, bg = p.bg })
hi("GitSignsChange", { fg = p.yellow, bg = p.bg })
hi("GitSignsDelete", { fg = p.red, bg = p.bg })
hi("SnacksIndent", { fg = "#2b2836", nocombine = true })
hi("SnacksIndentScope", { fg = "#3b3748", nocombine = true })
hi("SnacksIndentChunk", { fg = "#353143", nocombine = true })
hi("MiniIndentscopeSymbol", { fg = "#3b3748", nocombine = true })
hi("IblIndent", { fg = "#2b2836", nocombine = true })
hi("IblScope", { fg = "#3b3748", nocombine = true })

hi("RenderMarkdownCode", { bg = p.bg_code })
hi("RenderMarkdownCodeInline", { bg = p.bg_code })
hi("RenderMarkdownCodeBorder", { fg = p.split, bg = p.bg_code })
hi("RenderMarkdownCodeInfo", { fg = p.yellow, bg = p.bg_code, bold = true })
hi("RenderMarkdownCodeFallback", { fg = p.fg, bg = p.bg_code })

hi("NeoTreeNormal", { fg = p.fg, bg = p.bg })
hi("NeoTreeNormalNC", { fg = p.fg, bg = p.bg })

vim.g.colors_name = "kaku"

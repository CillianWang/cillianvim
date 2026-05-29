-- Extra colorschemes that resemble VSCode / Zed / Cursor default dark themes.
-- After :Lazy sync, switch with `:colorscheme <name>` and pick the variant you like.
--
-- Quick name reference (use these with :colorscheme):
--   vscode                       -- VSCode Dark+ (also what Cursor ships with)
--   ayu, ayu-dark, ayu-mirage    -- Ayu (classic IDE feel)
--   onedark, onedark_dark        -- One Dark Pro (Zed's default "One Dark")
--   catppuccin, catppuccin-mocha -- Catppuccin Mocha (modern Zed-ish)
--   kanagawa, kanagawa-wave      -- Kanagawa (warm dark, IDE-friendly)
--   tokyonight, tokyonight-night -- Tokyo Night
--   github_dark, github_dark_default -- GitHub Dark
--   nightfox, carbonfox, duskfox -- Nightfox family
--   rose-pine, rose-pine-moon    -- Rosé Pine
--   material, material-deep-ocean -- Material Deep Ocean (Zed-ish)
--   nord                         -- Nord
--   gruvbox-material             -- Modern Gruvbox

return {
  -- VSCode Dark+ (Cursor uses the same theme out of the box)
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "dark",
      transparent = false,
      italic_comments = true,
      color_overrides = {
        -- dim the default foreground (was #D4D4D4) so plain text is softer
        vscFront = "#B0B0B0",
      },
      group_overrides = {
        -- Faint, low-saturation diff backgrounds (no diagonal slashes — see
        -- fillchars.diff = " " in options.lua). Left side gets red for
        -- deletions; right side gets green for additions.
        DiffAdd    = { bg = "#1f2a1f" },
        DiffDelete = { bg = "#2a1f1f", fg = "NONE" },
        DiffChange = { bg = "#1f2330" },
        DiffText   = { bg = "#2e3a55" },

        -- Barely-visible current-line highlight (slightly lighter than bg)
        CursorLine = { bg = "#262626" },
      },
    },
  },

  -- Ayu Dark / Mirage / Light
  {
    "Shatur/neovim-ayu",
    lazy = true,
    priority = 1000,
    opts = { mirage = false, terminal = true },
  },

  -- One Dark Pro — Zed's default theme is built on One Dark
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Catppuccin — popular, Zed has a Catppuccin extension that matches
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = { flavour = "mocha", transparent_background = false },
  },

  -- Kanagawa — warm modern IDE colors
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Tokyo Night
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = { style = "night" },
  },

  -- GitHub Dark — close to VSCode GitHub theme
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    priority = 1000,
  },

  -- Nightfox family (nightfox / carbonfox / duskfox / nordfox / terafox)
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Rosé Pine
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
  },

  -- Material — Deep Ocean variant feels very Zed-like
  {
    "marko-cerovac/material.nvim",
    lazy = true,
    priority = 1000,
    init = function()
      vim.g.material_style = "deep ocean"
    end,
  },

  -- Nord
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Gruvbox Material — modernized Gruvbox, JetBrains-ish
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    priority = 1000,
    init = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
    end,
  },
}

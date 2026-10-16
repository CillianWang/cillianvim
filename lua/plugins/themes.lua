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
--   vague                        -- Vague (cool near-black, low contrast)
--   kanso, kanso-ink             -- Kanso (near-black ink variant, minimal mode on)
--   melange                      -- Melange (warm gray-black, tonal)
--   poimandres                   -- Poimandres (deep blue-black, minimal)
--   zenbones                     -- Zenbones (ultra low-contrast "zen")

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

        -- Keep the Dark+ hue and lightness, but reduce saturation by about 22%.
        -- This softens syntax, diagnostics, Git signs, and terminal ANSI colors
        -- without flattening the contrast between highlight groups.
        vscViolet = "#696B90",
        vscBlue = "#649BC8",
        vscAccentBlue = "#62BBEC",
        vscMediumBlue = "#319DE5",
        vscDisabledBlue = "#799BAC",
        vscLightBlue = "#A7D9F3",
        vscGreen = "#6D925C",
        vscBlueGreen = "#5CBBA8",
        vscLightGreen = "#B6CAAC",
        vscRed = "#E15A5A",
        vscOrange = "#C59581",
        vscLightRed = "#C67474",
        vscYellowOrange = "#CDB687",
        vscYellow = "#D6D6AF",
        vscDarkYellow = "#E3C31E",
        vscPink = "#BE8DBA",

        vscGitAdded = "#87B28F",
        vscGitModified = "#D9BE96",
        vscGitDeleted = "#B75949",
        vscGitRenamed = "#7CC094",
        vscGitUntracked = "#7CC094",
        vscGitStageModified = "#D9BE96",
        vscGitStageDeleted = "#B75949",
        vscGitConflicting = "#D67578",
        vscGitSubmodule = "#96B9D9",

        vscUiBlue = "#144465",
        vscUiOrange = "#DB8B3C",
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
    opts = {
      overrides = function(colors)
        return {
          -- Default LineNr (#54546D) is nearly invisible on the wave bg
          -- (#1F1F28); brighten it to the theme's comment gray.
          LineNr = { fg = colors.palette.fujiGray },
        }
      end,
    },
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

  -- Vague — cool near-black (#141415), low contrast, pastel accents
  {
    "vague-theme/vague.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Kanso — near-black "ink" variant; minimal mode keeps the palette tight
  {
    "webhooked/kanso.nvim",
    lazy = true,
    priority = 1000,
    opts = { minimal = true },
  },

  -- Melange — warm gray-black, control flow warm / data cold, very consistent
  {
    "savq/melange-nvim",
    lazy = true,
    priority = 1000,
  },

  -- Poimandres — deep blue-black, small disciplined palette
  {
    "olivercederborg/poimandres.nvim",
    lazy = true,
    priority = 1000,
  },

  -- Zenbones — ultra low-contrast "zen" family (needs lush.nvim)
  {
    "zenbones-theme/zenbones.nvim",
    dependencies = { "rktjmp/lush.nvim" },
    lazy = true,
    priority = 1000,
  },
}

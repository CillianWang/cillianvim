return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kaku",
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = "",
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    init = function()
      vim.g.lualine_laststatus = 3
      vim.o.laststatus = 3
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      end
    end,
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.disabled_filetypes = { statusline = { "alpha", "ministarter" } }
    end,
  },
  {
    "nvim-mini/mini.animate",
    opts = function(_, opts)
      local animate = require("mini.animate")
      opts.scroll = {
        timing = animate.gen_timing.linear({ duration = 90, unit = "total" }),
        subscroll = animate.gen_subscroll.equal(),
      }
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "lua-language-server",
        "pyright",
        "shellcheck",
        "shfmt",
        "stylua",
        "typescript-language-server",
      },
    },
  },
}

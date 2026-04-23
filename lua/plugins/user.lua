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
      opts.cursor = {
        enable = false,
      }
      opts.scroll = {
        enable = true,
        timing = animate.gen_timing.linear({ duration = 20, unit = "total" }),
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
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = true,
        },
      },
      file_panel = {
        win_config = {
          position = "left",
          width = 35,
        },
      },
    },
  },
}

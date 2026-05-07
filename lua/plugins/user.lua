return {
  {
    "iamcco/markdown-preview.nvim",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview Toggle" },
    },
    init = function()
      vim.g.mkdp_auto_start = 1
      vim.g.mkdp_auto_close = 1
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      heading = {
        -- icons placed before each heading level
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        -- fill the entire line with background color
        width = "full",
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.diagnostic.enable(false, { bufnr = 0 })
          vim.opt_local.spell = false
        end,
      })
      return { colorscheme = "kaku" }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 0,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "  <author>, <author_time:%Y-%m-%d> · <summary>",
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

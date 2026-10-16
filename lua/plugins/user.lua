return {
  {
    "folke/flash.nvim",
    opts = {
      -- Homerow-first priority order for jump labels
      labels = "asdfghjklqwertyuiopzxcvbnm",
      label = {
        -- Don't use uppercase labels; when single lowercase labels run out,
        -- flash falls back to multi-character labels instead.
        uppercase = false,
      },
    },
  },
  {
    "LudoPinelli/comment-box.nvim",
    keys = {
      { "<leader>cb", "<cmd>CBccbox<cr>",  desc = "Comment Box (centered)" },
      { "<leader>cl", "<cmd>CBccline<cr>", desc = "Comment Line (centered)" },
      { "<leader>cd", "<cmd>CBd<cr>",      desc = "Comment Box Delete" },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    -- On Apple Silicon the pre-built binary ships UNSIGNED and macOS SIGKILLs
    -- it (job fails with "Unknown system error -88"). Build the node app
    -- instead so it runs via `node app/index.js` (mkdp falls back to node
    -- when the pre-built binary isn't executable — keep it chmod -x'd).
    build = "cd app && npm install --no-audit --no-fund",
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
    -- Load before CodeCompanion creates its scratch buffer so the FileType
    -- event is never missed by render-markdown's attachment autocmd.
    lazy = false,
    opts = {
      file_types = { "markdown", "codecompanion" },
      overrides = {
        filetype = {
          codecompanion = {
            render_modes = true,
            -- Chat is a reading surface: keep Markdown rendered even when the
            -- cursor happens to be on a heading, emphasis, or code fence.
            anti_conceal = { enabled = false },
            padding = { highlight = "CodeCompanionChatNormal" },
            heading = {
              backgrounds = {
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
              },
              foregrounds = {
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
                "CodeCompanionMarkdownHeading",
              },
            },
            code = {
              -- Render a real, full-width code card: hide the backticks,
              -- retain the language label, and color every row including its
              -- top and bottom border.
              style = "full",
              width = "full",
              border = "thick",
              background_inset = 0,
              conceal_delimiters = true,
              language = true,
              language_icon = true,
              language_name = true,
              position = "left",
              left_pad = 1,
              right_pad = 1,
              highlight = "CodeCompanionMarkdownCode",
              highlight_info = "CodeCompanionMarkdownCodeInfo",
              highlight_border = "CodeCompanionMarkdownCodeBorder",
              highlight_fallback = "CodeCompanionMarkdownCodeInfo",
              highlight_inline = "CodeCompanionMarkdownInlineCode",
            },
          },
        },
      },
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
      return { colorscheme = "vague" }
    end,
  },
  -- Hide the tab/buffer line at the top
  { "akinsho/bufferline.nvim", enabled = false },

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
      indent = {
        -- Only draw the scope containing the cursor; hide all other guides.
        indent = { enabled = false },
        scope = {
          enabled = true,
          char = "┃",
          only_current = true,
        },
        chunk = { enabled = false },
        config = function()
          local indent = require("snacks.indent")
          if indent._kaku_scope_filter_installed then
            return
          end

          local render_scope = indent.render_scope
          indent.render_scope = function(scope, state)
            if (scope.indent or 0) == 0 or scope:size() > 40 then
              return
            end
            return render_scope(scope, state)
          end
          indent._kaku_scope_filter_installed = true
        end,
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

      -- The CodeCompanion chat float is named "[CodeCompanion] N"; with
      -- globalstatus the statusline would show that title whenever the chat
      -- is focused. Hide the buffer-title components inside the chat window.
      opts.sections = opts.sections or {}
      opts.sections.lualine_c = opts.sections.lualine_c or {}
      for i, comp in ipairs(opts.sections.lualine_c) do
        local cond = type(comp) == "table" and comp.cond or nil
        local function not_in_chat()
          if vim.bo.filetype == "codecompanion" then
            return false
          end
          return cond == nil or cond()
        end
        if type(comp) == "table" then
          comp.cond = not_in_chat
        elseif type(comp) == "function" then
          opts.sections.lualine_c[i] = { comp, cond = not_in_chat }
        end
      end

      -- Add our own trouble breadcrumb. LazyVim's default is disabled via
      -- vim.g.trouble_lualine = false (set in options.lua) because its
      -- {kind_icon} segments use a separate highlight group with a bg that
      -- never matches the surrounding lualine section. Ours uses "> " as
      -- plain text inline with the symbol name, so it picks up the section bg.
      local ok, trouble = pcall(require, "trouble")
      if ok then
        opts.sections = opts.sections or {}
        opts.sections.lualine_c = opts.sections.lualine_c or {}
        local symbols = trouble.statusline({
          mode = "symbols",
          groups = {},
          title = false,
          filter = { range = true },
          format = "> {symbol.name}",
          -- no hl_group → trouble doesn't run fix_statusline; segments use Normal
        })
        table.insert(opts.sections.lualine_c, {
          symbols and symbols.get,
          cond = function()
            return vim.b.trouble_lualine ~= false and symbols.has()
          end,
        })
      end
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

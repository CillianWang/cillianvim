return {
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    cmd = {
      "DistantConnect",
      "DistantInstall",
      "DistantLaunch",
      "DistantOpen",
      "DistantShell",
    },
    keys = {
      {
        "<leader>rc",
        function()
          vim.ui.input({ prompt = "Connect to (ssh://user@host): " }, function(input)
            if input and input ~= "" then
              vim.cmd("DistantConnect " .. input)
            end
          end)
        end,
        desc = "Distant: Connect (ssh)",
      },
      { "<leader>ro", "<cmd>DistantOpen<cr>", desc = "Distant: Open remote path" },
      { "<leader>rs", "<cmd>DistantShell<cr>", desc = "Distant: Remote shell" },
    },
    config = function()
      require("distant"):setup()

      -- Silence "No active client available!" errors that fire when
      -- blink.cmp triggers cmdline completion for :Distant* before connecting.
      vim.schedule(function()
        for name, fn in pairs(_G) do
          if type(name) == "string" and name:match("^DistantCommandComplete_") and type(fn) == "function" then
            _G[name] = function(...)
              local ok, result = pcall(fn, ...)
              return ok and result or ""
            end
          end
        end
      end)
    end,
  },
}

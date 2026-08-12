-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local keymap_help = require("config.keymap_help")

-- Searchable Markdown help for every active global and buffer-local keymap
map("n", "<leader>;", keymap_help.open, { desc = "Show all keymaps" })

-- Easier split creation
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize split sizes" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close current split" })

-- Easier split navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right split" })

-- Faster vertical movement
map("n", "L", "20j", { desc = "Move down 20 lines" })
map("n", "H", "20k", { desc = "Move up 20 lines" })

-- Buffer navigation
map("n", "<leader>h", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>l", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Terminal workflow
map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Terminal in vertical split" })
map("n", "<leader>th", "<cmd>split | terminal<cr>", { desc = "Terminal in horizontal split" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Floating terminal (override LazyVim/snacks defaults that open a bottom split)
local function float_term()
  Snacks.terminal(nil, {
    win = {
      position = "float",
      border = "rounded",
      height = 0.8,
      width = 0.8,
    },
  })
end
map({ "n", "t" }, "<C-/>", float_term, { desc = "Toggle floating terminal" })
map({ "n", "t" }, "<C-_>", float_term, { desc = "Toggle floating terminal" })
map("n", "<leader>ft", float_term, { desc = "Floating terminal" })
map("n", "<leader>fT", float_term, { desc = "Floating terminal" })

-- Quit Neovim entirely
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })

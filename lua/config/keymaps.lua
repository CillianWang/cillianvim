-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

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

-- Terminal workflow
map("n", "<leader>tv", "<cmd>vsplit | terminal<cr>", { desc = "Terminal in vertical split" })
map("n", "<leader>th", "<cmd>split | terminal<cr>", { desc = "Terminal in horizontal split" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quit Neovim entirely
map("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit all" })

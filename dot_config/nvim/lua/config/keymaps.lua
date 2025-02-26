-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<bs>", "<C-o>", { desc = "Jump Out" })
vim.keymap.set("n", "<del>", "<C-i>", { desc = "Jump In" })

vim.keymap.set("n", "<Up>", "<Cmd>execute 'move .-' . (v:count1 + 1)<CR>==", { desc = "Move up" })
vim.keymap.set("n", "<Down>", "<Cmd>execute 'move .+' . v:count1<CR>==", { desc = "Move up" })
vim.keymap.set("v", "<Up>", ":<C-U>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", { desc = "Move up" })
vim.keymap.set("v", "<Down>", ":<C-U>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", { desc = "Move down" })

vim.keymap.del({ "n", "v" }, "<M-j>")
vim.keymap.del({ "n", "v" }, "<M-k>")

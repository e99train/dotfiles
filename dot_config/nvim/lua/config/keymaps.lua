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

-- incremental selection treesitter/lsp
vim.keymap.set({ "v" }, "+", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "v" }, "-", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })

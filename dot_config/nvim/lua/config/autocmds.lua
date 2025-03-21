-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
-- vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
--   pattern = {
--     "Fastfile",
--     "Appfile",
--     "Matchfile",
--     "Pluginfile",
--   },
--   command = "set filetype=ruby",
-- })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = {
    ".env",
    "*.env",
    ".env.*",
  },
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

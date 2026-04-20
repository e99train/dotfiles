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

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*",
  callback = function()
    local clients = vim.lsp.get_clients({ name = "roslyn" })
    if not clients or #clients == 0 then
      return
    end

    local buffers = clients[1].attached_buffers
    for buf, _ in ipairs(buffers) do
      local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
      clients[1]:request("textDocument/diagnostic", params, nil, buf)
    end
  end,
})

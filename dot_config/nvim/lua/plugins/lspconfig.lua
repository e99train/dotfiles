return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      -- sqls is not reliably auto-enabled by mason-lspconfig (registry timing),
      -- so start it explicitly on SQL buffers.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql" },
        callback = function(args)
          if vim.lsp.is_enabled("sqls") == false then
            vim.lsp.enable("sqls")
          end
          local attached = false
          for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
            if c.name == "sqls" then
              attached = true
              break
            end
          end
          if not attached then
            vim.lsp.start(vim.lsp.config.sqls, { bufnr = args.buf })
          end
        end,
      })
    end,
    opts = {
      servers = {
        sqls = {
          mason = false,
          cmd = { vim.fn.stdpath("data") .. "/mason/bin/sqls" },
          root_dir = function(bufnr)
            return vim.fs.root(bufnr, { ".git", "config.yml" }) or vim.fn.getcwd()
          end,
        },
      },
    },
  },
}

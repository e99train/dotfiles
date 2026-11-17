return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      if type(opts.ensure_installed) ~= "table" then
        opts.ensure_installed = {}
      end
      -- remove sqlfluff (uninstalled) so Mason doesn't reinstall it
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "sqlfluff"
      end, opts.ensure_installed)
      -- install sqls LSP (not in mason-lspconfig's auto-map)
      if not vim.tbl_contains(opts.ensure_installed, "sqls") then
        table.insert(opts.ensure_installed, "sqls")
      end
    end,
  },
}
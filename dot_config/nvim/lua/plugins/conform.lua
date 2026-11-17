return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.default_format_opts.lsp_format = "fallback"
    -- opts.formatters_by_ft.cs = nil
    -- opts.formatters.csharpier = {
    --   inherit = false,
    --   command = "csharpier",
    --   args = { "format", "$FILENAME", "--write-stdout" },
    -- }
    opts.formatters_by_ft.cs = { "csharpier", lsp_format = "first" }
    -- sqlfluff removed (not installed); avoid ENOENT on .sql files
    opts.formatters_by_ft.json = { "fixjson" }
    opts.formatters_by_ft.swift = { "swiftformat" }
    -- opts.formatters_by_ft.xml = { "csharpier" }
    opts.formatters.csharpier = {
      command = "dotnet",
      args = { "csharpier", "format", "--write-stdout" },
    }
    -- strip any sqlfluff entries added by LazyVim sql extra
    for _, ft in ipairs({ "sql", "mysql", "plsql" }) do
      if type(opts.formatters_by_ft[ft]) == "table" then
        opts.formatters_by_ft[ft] = vim.tbl_filter(function(f)
          return f ~= "sqlfluff"
        end, opts.formatters_by_ft[ft])
        if #opts.formatters_by_ft[ft] == 0 then
          opts.formatters_by_ft[ft] = nil
        end
      end
    end
    opts.formatters.sqlfluff = nil
    -- opts.log_level = vim.log.levels.DEBUG
  end,
}
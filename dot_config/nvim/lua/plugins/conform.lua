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
    opts.formatters_by_ft.sql = { "sqlfluff" }
    opts.formatters_by_ft.json = { "fixjson" }
    -- opts.formatters_by_ft.xml = { "csharpier" }
    opts.formatters.csharpier = {
      command = "dotnet",
      args = { "csharpier", "format", "--write-stdout" },
    }
    opts.formatters.sqlfluff = {
      command = "sqlfluff",
      args = { "format", "--dialect=ansi", "-" },
      stdin = true,
      cwd = function()
        return vim.fn.getcwd()
      end,
    }
    -- opts.log_level = vim.log.levels.DEBUG
  end,
}

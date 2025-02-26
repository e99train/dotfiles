return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.default_format_opts.lsp_format = "first"
    opts.formatters_by_ft.cs = nil
  end,
}

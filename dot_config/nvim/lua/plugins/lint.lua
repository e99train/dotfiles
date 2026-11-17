return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    opts.linters_by_ft.swift = { "swiftlint" }
    -- sqlfluff removed (not installed); avoid ENOENT on .sql files
    for _, ft in ipairs({ "sql", "mysql", "plsql" }) do
      if type(opts.linters_by_ft[ft]) == "table" then
        opts.linters_by_ft[ft] = vim.tbl_filter(function(l)
          return l ~= "sqlfluff"
        end, opts.linters_by_ft[ft])
        if #opts.linters_by_ft[ft] == 0 then
          opts.linters_by_ft[ft] = nil
        end
      end
    end
  end,
}
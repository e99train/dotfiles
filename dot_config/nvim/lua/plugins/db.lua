return {
  {
    "Kurren123/mssql.nvim",
    opts = {
      keymap_prefix = "<leader>m",
      lsp_settings = {
        format = false,
      },
    },
    dependencies = {
      "folke/which-key.nvim",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "Kurren123/mssql.nvim" },
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, require("mssql").lualine_component)
      return opts
    end,
  },
}

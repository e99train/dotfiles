return {
  {
    "mistweaverco/kulala.nvim",
    keys = {
      {
        "<leader>Re",
        function()
          require("kulala").set_selected_env()
        end,
        desc = "Select env",
        ft = "http",
      },
    },
    opts = {
      lsp = {
        formatter = false,
        keymaps = {
          ["<leader>ca"] = { vim.lsp.buf.code_action, desc = "Code Action" },
          ["K"] = { vim.lsp.buf.hover, desc = "Hover" },
        },
      },
      ui = {
        show_variable_info_text = true,
      },
      global_keymaps = false,
    },
  },
  -- {
  --   dir = "~/projects/kulala.nvim",
  --   keys = {
  --     {
  --       "<leader>Re",
  --       function()
  --         require("kulala").set_selected_env()
  --       end,
  --       desc = "Select env",
  --       ft = "http",
  --     },
  --   },
  -- },
}

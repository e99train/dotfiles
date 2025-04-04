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
      global_keymaps = true,
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

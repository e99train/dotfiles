return {
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { { "nvim-lua/plenary.nvim", lazy = true } },
    keys = {
      {
        "<leader>y",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Yazi open",
      },
      {
        "<leader>Yr",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume last Yazi session",
      },
    },
  },
}

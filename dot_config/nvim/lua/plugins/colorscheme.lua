return {
  -- {
  --   "bluz71/vim-moonfly-colors",
  --   name = "moonfly",
  --   lazy = false,
  --   priority = 1000,
  -- },

  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("rose-pine").setup({
  --       -- palette = {
  --       --   main = {
  --       --     base = "#020202",
  --       --   },
  --       -- },
  --     })
  --   end,
  -- },

  -- {
  --   "navarasu/onedark.nvim",
  --   priority = 1000,
  --   opts = {
  --     style = "darker",
  --   },
  -- },

  {
    "miikanissi/modus-themes.nvim",
    priority = 1000,
    opts = {
      style = "modus_vivendi",
    },
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "modus",
    },
  },
}

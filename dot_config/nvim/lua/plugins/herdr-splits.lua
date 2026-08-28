return {
  "lmilojevicc/herdr-splits.nvim",
  cond = vim.env.HERDR_ENV == "1",
  event = "VeryLazy",
  config = function()
    require("herdr-splits").setup({
      -- Ctrl-h/j/k/l for navigation (matching requested keymaps)
      nav_keys = { left = "<C-h>", down = "<C-j>", up = "<C-k>", right = "<C-l>" },
      resize_keys = { left = "<C-Left>", down = "<C-Down>", up = "<C-Up>", right = "<C-Right>" },
    })
  end,
  keys = {
    { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Navigate left" },
    { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Navigate down" },
    { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Navigate up" },
    { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Navigate right" },
    { "<C-Left>", function() require("herdr-splits").resize_left() end, desc = "Resize left" },
    { "<C-Down>", function() require("herdr-splits").resize_down() end, desc = "Resize down" },
    { "<C-Up>", function() require("herdr-splits").resize_up() end, desc = "Resize up" },
    { "<C-Right>", function() require("herdr-splits").resize_right() end, desc = "Resize right" },
  },
}

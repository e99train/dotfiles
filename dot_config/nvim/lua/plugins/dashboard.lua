return {
  {
    "echasnovski/mini.starter",
    lazy = false,
    config = function()
      require("mini.starter").setup({
        autoopen = true,
        items = {
          require("mini.starter").sections.builtin_actions(),
          require("mini.starter").sections.recent_files(5, true, false),
          {
            name = "Oil File Explorer",
            action = function()
              require("oil").open()
            end,
            section = "Find",
          },
          {
            name = "Find Files",
            action = LazyVim.pick(),
            section = "Find",
          },
          {
            name = "Restore Previous Session",
            action = function()
              require("persistence").load({ last = true })
            end,
            section = "Sessions",
          },
          { name = "Lazy", action = "Lazy", section = "Lazy" },
        },
        header = [[
             __   __     ______     ______     __   __   __     __    __
            /\ "-.\ \   /\  ___\   /\  __ \   /\ \ / /  /\ \   /\ "-./  \
            \ \ \-.  \  \ \  __\   \ \ \/\ \  \ \ \'/   \ \ \  \ \ \-./\ \
             \ \_\\"\_\  \ \_____\  \ \_____\  \ \__|    \ \_\  \ \_\ \ \_\
              \/_/ \/_/   \/_____/   \/_____/   \/_/      \/_/   \/_/  \/_/
                                                                ]],
        -- footer = function()
        --     local stats = require("lazy.stats").stats()
        --     local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        --     return "Startup Time: " .. ms .. " ms"
        -- end,
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      dashboard = { enabled = false },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      toggle = { map = LazyVim.safe_keymap_set },
      picker = {
        hidden = true,
      },
    },
  },
}

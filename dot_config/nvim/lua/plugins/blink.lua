return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
    },
    sources = {
      default = { "ecolog", "lsp", "path", "snippets", "buffer" },
      providers = {
        ecolog = { name = "ecolog", module = "ecolog.integrations.cmp.blink_cmp" },
      },
    },
  },
}

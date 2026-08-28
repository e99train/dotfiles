return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsgo = {
          -- Override standard 'tsgo' command to use the official stable release
          cmd = { "tsc", "--lsp", "--stdio" },
        },
      },
    },
  },
}

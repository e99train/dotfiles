return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    LazyVim.lsp.on_attach(function(client, buffer)
      if client.name == "omnisharp" then
        LazyVim.notify("Omnisharp LSP Attached")
      end
      if client.name == "roslyn" then
        LazyVim.notify("Roslyn LSP Attached")
      end
    end)
  end,
}

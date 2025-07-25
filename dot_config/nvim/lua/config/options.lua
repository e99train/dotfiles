-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.textwidth = 120

vim.filetype.add({
  pattern = {
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})

vim.lsp.enable("gh_actions_ls")
vim.lsp.config("gh_actions_ls", {
  filetypes = { "yaml.github" },
  single_file_support = false,
  init_options = {
    sessionToken = os.getenv("GITHUB_LS_TOKEN"),
  },
})

vim.lsp.config("roslyn", {
  cmd = {
    "dotnet",
    "/Users/ethanborsky/.local/share/nvim/roslyn/Microsoft.CodeAnalysis.LanguageServer.dll",
    "--logLevel=Information",
    "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
    "--stdio",
  },
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
    ["csharp|completion"] = {
      dotnet_show_completion_items_from_unimported_namespaces = true,
    },
  },
})

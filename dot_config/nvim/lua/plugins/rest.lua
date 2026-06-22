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
      global_keymaps = true,
      kulala_keymaps = {
        ["Next tab"] = false,
        ["Previous tab"] = false,
        ["Show headers"] = {
          "H",
          function()
            require("kulala.ui").show_headers()
          end,
        },
        ["Show body"] = {
          "B",
          function()
            require("kulala.ui").show_body()
          end,
        },
        ["Show headers and body"] = {
          "A",
          function()
            require("kulala.ui").show_headers_body()
          end,
        },
        ["Show verbose"] = {
          "V",
          function()
            require("kulala.ui").show_verbose()
          end,
        },
        ["Show script output"] = {
          "O",
          function()
            require("kulala.ui").show_script_output()
          end,
        },
        ["Show stats"] = {
          "S",
          function()
            require("kulala.ui").show_stats()
          end,
        },
        ["Show report"] = {
          "R",
          function()
            require("kulala.ui").show_report()
          end,
        },
        ["Show filter"] = {
          "F",
          function()
            require("kulala.ui").toggle_filter()
          end,
        },
        ["Next response"] = {
          "]",
          function()
            require("kulala.ui").show_next()
          end,
          prefix = false,
        },
        ["Previous response"] = {
          "[",
          function()
            require("kulala.ui").show_previous()
          end,
          prefix = false,
        },
        ["Jump to response"] = {
          "<CR>",
          function()
            require("kulala.ui").keymap_enter()
          end,
          mode = { "n", "v" },
          desc = "Jump to request",
          prefix = false,
        },
        ["Clear responses history"] = {
          "X",
          function()
            require("kulala.ui").clear_responses_history()
          end,
        },
        ["Send WS message"] = {
          "<S-CR>",
          function()
            require("kulala.ui.ws_input").on_send_keymap()
          end,
          mode = { "n", "v", "i" },
          desc = "Open WS message input (body view) / send from input overlay",
          prefix = false,
        },
        ["Interrupt requests"] = {
          "<C-c>",
          function()
            require("kulala.ui").interrupt_requests()
          end,
          desc = "also: CLose WS connection",
          prefix = false,
        },
        ["Show help"] = {
          "?",
          function()
            require("kulala.ui").show_help()
          end,
          prefix = false,
        },
        ["Show news"] = {
          "g?",
          function()
            require("kulala.ui").show_news()
          end,
          prefix = false,
        },
        ["Toggle split/float"] = {
          "|",
          function()
            require("kulala.ui").toggle_display_mode()
          end,
          prefix = false,
        },
        ["Close"] = {
          "q",
          function()
            require("kulala.ui").close_kulala_buffer()
          end,
          prefix = false,
        },
      },
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

return {
  "mistweaverco/kulala",
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
}

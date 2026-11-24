-- Seamless navigation between nvim splits and Rex panes with Ctrl-h/j/k/l.
-- Rex passes ctrl+h/j/k/l through to nvim (see rex/init.lua); when nvim is
-- already at the edge in that direction, it asks Rex to move pane focus.
if not vim.env.REX_SESSION then
  return {}
end

local rex_bin = vim.fn.exepath("rex")

local function navigate(wincmd, direction)
  local win = vim.api.nvim_get_current_win()
  vim.cmd("wincmd " .. wincmd)
  if vim.api.nvim_get_current_win() == win and rex_bin ~= "" then
    vim.system({ rex_bin, "focus", "-s", vim.env.REX_SESSION, direction })
  end
end

local function map(lhs, wincmd, direction, desc)
  vim.keymap.set({ "n", "x" }, lhs, function() navigate(wincmd, direction) end, { desc = desc })
  vim.keymap.set("t", lhs, function()
    vim.cmd("stopinsert")
    navigate(wincmd, direction)
  end, { desc = desc })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  once = true,
  callback = vim.schedule_wrap(function()
    map("<C-h>", "h", "left", "Navigate left (nvim/Rex)")
    map("<C-j>", "j", "down", "Navigate down (nvim/Rex)")
    map("<C-k>", "k", "up", "Navigate up (nvim/Rex)")
    map("<C-l>", "l", "right", "Navigate right (nvim/Rex)")
  end),
})

return {}

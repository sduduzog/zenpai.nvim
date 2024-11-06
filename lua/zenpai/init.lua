local M = {}

local window = require "zenpai.window"

local function on_prompt_input(input)
  local response = "Response to: " .. input
  local buf = window.get_state().buf
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { response })
  end
end

local function toggle_window()
  local win = window.get_state().win
  if win and vim.api.nvim_win_is_valid(win) then
    window.close_window()
  else
    window.open_window(on_prompt_input)
  end
end

function M.setup(opts)
  opts = opts or {}

  vim.keymap.set("n", "<Leader>i", toggle_window)
end

return M

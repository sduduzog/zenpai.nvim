local M = {}

local state = {
  win = nil,
  buf = nil,
}

function M.get_state()
  return state
end

function M.open_window(on_prompt_input)
  -- window dimensions
  local width = 60
  local height = 15

  -- create an empty buffer for our window
  local buf = vim.api.nvim_create_buf(false, true)

  -- get editor dimensions to center our window
  local win_height = vim.opt.lines:get()
  local win_width = vim.opt.columns:get()

  -- calculate center position
  local row = math.floor((win_height - height) / 4)
  local col = math.floor((win_width - width) / 2)

  -- configure window options
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  -- create and open the floating window
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- store window and buffer IDs
  state.win = win
  state.buf = buf

  -- set window options
  vim.wo[win].wrap = true
  vim.bo[buf].modifiable = true
  vim.bo[buf].buftype = "prompt"

  -- set up the prompt
  local prompt_prefix = "zAI > "
  vim.fn.prompt_setprompt(buf, prompt_prefix)
  vim.fn.prompt_setcallback(buf, on_prompt_input)

  vim.api.nvim_command "startinsert"
  vim.api.nvim_buf_set_keymap(
    buf,
    "i",
    "<Esc>",
    "<cmd>lua require('zenpai.window').close_window()<CR>",
    { noremap = true, silent = true }
  )
end

function M.close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
  end

  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
  end

  state.win = nil
  state.buf = nil
end

return M

local M = {}

local window = require "zenpai.window"
local git_cmd = require "zenpai.git_cmd"

local function on_prompt_input(input)
  local response = ""

  if input ~= "gen" then
    return
  end

  if not git_cmd.is_git_repo() then
    response = "not a git repository."
  elseif not git_cmd.has_changes() then
    response = "no changes to commit."
  else
    local files_to_stage = git_cmd.files_to_be_staged()
    if not files_to_stage then
      return
    end

    local prompt_msg = string.format("%s\nstage these files? (y/n): ", files_to_stage)
    local confirm = vim.fn.input(prompt_msg):lower()

    if confirm ~= "y" and confirm ~= "yes" then
      vim.notify("staging aborted.", vim.log.levels.INFO)
      return
    end

    git_cmd.stage_files()
    vim.notify("files staged successfully.", vim.log.levels.INFO)

    local diff = git_cmd.get_diff()
    vim.notify(diff, vim.log.levels.INFO)
  end

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

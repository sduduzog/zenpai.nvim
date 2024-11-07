local M = {}

local Menu = require "nui.menu"
local git_cmd = require "zenpai.git_cmd"

local function generate_commit()
  if not git_cmd.is_git_repo() then
    vim.notify("not a git repository.", vim.log.levels.INFO)
  elseif not git_cmd.has_changes() then
    vim.notify("no changes to commit.", vim.log.levels.INFO)
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
end

local function menu_option_selected(item)
  if item.id == 1 then
    generate_commit()
  end
end

local menu = Menu({
  position = "50%",
  size = {
    width = 25,
    height = 5,
  },
  border = {
    style = "single",
    text = {
      top = "[Choose Action]",
      top_align = "center",
    },
  },
  win_options = {
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
}, {
  lines = {
    Menu.item("Commit Changes", { id = 1 }),
  },
  max_width = 20,
  keymap = {
    focus_next = { "j", "<Down>", "<Tab>" },
    focus_prev = { "k", "<Up>", "<S-Tab>" },
    close = { "<Esc>", "<C-c>" },
    submit = { "<CR>", "<Space>" },
  },
  on_submit = menu_option_selected,
})

function M.setup(opts)
  opts = opts or {}
  vim.keymap.set("n", "<Leader>i", function()
    menu:mount()
  end)
end

return M

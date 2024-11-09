local M = {}
local Job = require "plenary.job"

local function run_command(cmd, opts)
  opts = opts or {}
  local result = {}
  local job = Job:new {
    command = cmd[1],
    args = vim.list_slice(cmd, 2),
    on_stdout = function(_, data)
      table.insert(result, data)
    end,
    on_stderr = function(_, data)
      if opts.show_error then
        vim.notify("Error: " .. data, vim.log.levels.ERROR)
      end
    end,
    on_exit = function(_, return_val)
      if opts.on_exit then
        opts.on_exit(return_val)
      end
    end,
  }

  job:sync()
  return table.concat(result, "\n")
end

function M.is_git_repo()
  local output = run_command { "git", "rev-parse", "--is-inside-work-tree" }
  return output == "true"
end

function M.has_changes()
  local output = run_command { "git", "status", "--porcelain" }
  return output ~= ""
end

function M.current_branch()
  return run_command { "git", "rev-parse", "--abbrev-ref", "HEAD" }
end

function M.files_to_be_staged()
  local status = run_command { "git", "status", "--porcelain" }
  if status ~= "" then
    return "Files to be staged:\n" .. status
  else
    return nil
  end
end

function M.stage_files()
  run_command({ "git", "add", "." }, { show_error = true })
end

function M.commit(commit_msg)
  run_command({ "git", "commit", "-m", commit_msg }, { show_error = true })
  return vim.v.shell_error == 0
end

function M.create_branch(branch_name)
  run_command({ "git", "checkout", "-b", branch_name }, { show_error = true })
  return vim.v.shell_error == 0
end

function M.get_diff()
  local staged_diff = run_command { "git", "diff", "--staged" }
  local unstaged_diff = run_command { "git", "diff" }
  local diff = {}

  if staged_diff ~= "" then
    table.insert(diff, "Staged Changes:\n" .. staged_diff)
  end

  if unstaged_diff ~= "" then
    table.insert(diff, "\nUnstaged Changes:\n" .. unstaged_diff)
  end

  return table.concat(diff, "\n\n")
end
return M

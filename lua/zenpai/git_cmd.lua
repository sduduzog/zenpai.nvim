local M = {}

local function run_command(cmd)
  return table.concat(vim.fn.systemlist(cmd), "\n")
end

function M.is_git_repo()
  return run_command "git rev-parse --is-inside-work-tree" == "true"
end

function M.has_changes()
  return run_command "git status --porcelain" ~= ""
end

function M.files_to_be_staged()
  local status = run_command "git status --porcelain"
  if status ~= "" then
    return "Files to be staged:\n" .. status
  else
    return nil -- No files to stage
  end
end

function M.stage_files()
  run_command "git add ."
end

function M.commit(commit_msg)
  run_command('git commit -m "' .. commit_msg .. '"')
  return vim.v.shell_error == 0
end

function M.get_diff()
  local staged_diff = run_command "git diff --staged"
  local unstaged_diff = run_command "git diff"
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

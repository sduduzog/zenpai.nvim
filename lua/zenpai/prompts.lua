local M = {}

function M.commit_msg_prompt(diff)
  local prompt = [[
    Generate a git commit message based on the output of a diff command.
    Summarize the change in less than 50 characters

    Because:
    - Explain the reasons you made this change
    - Make a new bullet for each reason
    - Each line should be under 72 characters
    - Don't include the "Because:" in the commit.

    Here is the diff output:
    ]]

  return prompt .. "\n" .. diff
end

return M

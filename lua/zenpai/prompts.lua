local M = {}

function M.commit_msg_prompt(diff)
  local prompt = [[
    Generate a git commit message for the following diff output. Follow these rules:

    1. First line must:
      - Start with a type (feat/fix/refactor/style/test/docs/chore)
      - Use the format: type: description
      - Be less than 50 characters 
      - Use imperative mood ("add" not "added")


    3. The body must:
      - Leave one blank line after the title
      - Limit to key points; avoid unnecessary detail
      - Wrap lines at 72 characters
      - Use bullet points ("-") in imperative mood
      - Mention specific functions, variables, or components changed
      - Describe *what* was changed and *why* it matters, in brief

    Return only the commit message text.

    Here is the diff output:
    ]]

  return prompt .. "\n" .. diff
end

return M

local M = {}

function M.commit_msg_prompt(diff)
  local prompt = [[
    Generate a concise git commit message for this diff. Rules:

    Title line (50 chars max):
      - Format: type: description
      - Type must be: feat/fix/refactor/style/test/docs/chore
      - Use imperative ("add" not "added" )

    Body:
      - Leave one blank line after title
      - Use bullet points (-)
      - Number of bullets should match scope of changeset
      - Mark function names, variables and components with backticks 
      - Focus on WHAT changed and WHY it matters
      - Keep it short but meaningful
      - Wrap at 72 chars

    <Important>
    Output raw text only, no markup or backticks around the commit message.
    </Important>

    Here is the diff output:
    ]]

  return prompt .. "\n" .. diff
end

return M

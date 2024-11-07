local curl = require "plenary.curl"

local M = {}

local function request(endpoint, body, on_data, on_complete)
  local api_key = os.getenv "OPENAI_API_KEY"
  if not api_key or api_key == "" then
    on_complete "$OPENAI_API_KEY environment variable must be set."
    return
  end

  local url = "https://api.openai.com/v1/" .. endpoint
  local headers = {
    ["Content-Type"] = "application/json",
    ["Authorization"] = "Bearer " .. api_key,
  }

  curl.post(url, {
    headers = headers,
    body = vim.fn.json_encode(body),
    callback = function(response)
      vim.schedule(function()
        if response.status == 200 then
          local data = vim.fn.json_decode(response.body)
          on_data(data)
        else
          on_complete("Error: " .. response.status .. " - " .. response.body)
        end
      end)
    end,
  })
end

function M.completions(body, on_data, on_complete)
  body = vim.tbl_extend("keep", body, {
    model = "gpt-4o-mini",
    max_tokens = 1000,
    temperature = 0,
    stream = false,
  })

  request("chat/completions", body, on_data, on_complete)
end

return M

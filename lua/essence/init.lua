---@class EssenceConfig
---@field conceal boolean Enable concealing of operators with Unicode symbols (default: false)

local M = {}

---@type EssenceConfig
local default_config = {
  conceal = false,
}

---@type EssenceConfig
M.config = vim.deepcopy(default_config)

---Setup essence.nvim plugin
---@param opts? EssenceConfig User configuration options
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", default_config, opts or {})

  -- Set global variable for syntax file compatibility
  if M.config.conceal then
    vim.g.essence_conceal = 1
  else
    vim.g.no_essence_conceal = 1
  end
end

return M

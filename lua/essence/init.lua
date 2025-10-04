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
end

-- Lazy-load conceal module
local conceal = nil
local function get_conceal()
	if not conceal then
		conceal = require("essence.conceal")
	end
	return conceal
end

---Enable concealment for the current buffer
---@param bufnr? integer Buffer number (nil for current buffer)
---@return boolean success
function M.conceal_enable(bufnr)
	return get_conceal().enable(bufnr)
end

---Disable concealment for the current buffer
---@param bufnr? integer Buffer number (nil for current buffer)
---@return boolean success
function M.conceal_disable(bufnr)
	return get_conceal().disable(bufnr)
end

---Toggle concealment for the current buffer
---@param bufnr? integer Buffer number (nil for current buffer)
---@return boolean new_state
function M.conceal_toggle(bufnr)
	return get_conceal().toggle(bufnr)
end

---Check if concealment is enabled for a buffer
---@param bufnr? integer Buffer number (nil for current buffer)
---@return boolean
function M.conceal_is_enabled(bufnr)
	return get_conceal().is_enabled(bufnr)
end

---Enable concealment globally for all essence buffers
---@return boolean success
function M.conceal_enable_global()
	return get_conceal().enable_global()
end

---Disable concealment globally for all essence buffers
---@return boolean success
function M.conceal_disable_global()
	return get_conceal().disable_global()
end

---Toggle concealment globally
---@return boolean new_state
function M.conceal_toggle_global()
	return get_conceal().toggle_global()
end

---Get concealment status for a buffer
---@param bufnr? integer Buffer number (nil for current buffer)
---@return table status Status information table
function M.conceal_status(bufnr)
	return get_conceal().status(bufnr)
end

return M

---@class IconConfig
---@field icon string Icon glyph to display
---@field color string Icon color (hex format)
---@field hl string Highlight group for mini.icons

---@class EssenceConfig
---@field conceal boolean Enable concealing of operators with Unicode symbols (default: false)
---@field icon IconConfig Icon configuration for the essence filetype

local M = {}

---@type EssenceConfig
local default_config = {
  conceal = false,
  icon = {
    icon = "",
    color = "#56b6c2",
    hl = "MiniIconsCyan",
  },
}

---@type EssenceConfig
M.config = vim.deepcopy(default_config)

---Setup filetype icons for essence
local function setup_icons()
  local icon_config = M.config.icon
  -- Try mini.icons first (preferred)
  local has_mini_icons, mini_icons = pcall(require, "mini.icons")
  if has_mini_icons then
    local current_config = mini_icons.config or {}
    local new_config = vim.tbl_deep_extend("force", current_config, {
      filetype = {
        essence = { glyph = icon_config.icon, hl = icon_config.hl },
      },
    })
    mini_icons.setup(new_config)
    mini_icons.mock_nvim_web_devicons()
    return
  end

  -- TODO: add support for nvim-web-devicons
end

---Setup essence.nvim plugin
---@param opts? EssenceConfig User configuration options
function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", default_config, opts or {})
  setup_icons()
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

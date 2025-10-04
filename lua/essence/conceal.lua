-- lua/essence/conceal.lua
-- Concealment management for essence.nvim

local M = {}

-- Check if concealing is supported
---@return boolean
local function has_conceal_support()
  return vim.fn.has("conceal") == 1 and vim.o.encoding == "utf-8"
end

-- Apply concealment syntax rules to the current buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
local function apply_conceal_syntax(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Check if this is an essence buffer
  if vim.bo[bufnr].filetype ~= "essence" then
    return
  end

  -- Clear existing conceal syntax
  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.cmd, "syntax clear essenceNiceOperator")
  end)

  -- Define conceal syntax groups
  local conceal_keywords = {
    { "exists", "∃" },
    { "forAll", "∀" },
    { "in", "∈" },
    { "intersect", "∩" },
    { "lambda", "λ" },
    { "subset", "⊂" },
    { "subsetEq", "⊆" },
    { "sum", "∑" },
    { "supset", "⊃" },
    { "supsetEq", "⊇" },
    { "union", "∪" },
  }

  local conceal_matches = {
    { "\\*", "×" },
    { "!", "¬" },
    { "->", "⇒" },
    { "<->", "⇔" },
    { "!=", "≠" },
    { "<=", "≤" },
    { ">=", "≥" },
    { "/\\\\", "∧" },
    { "\\\\/", "∨" },
    { "-->", "→" },
  }

  vim.api.nvim_buf_call(bufnr, function()
    -- Add keyword conceal rules
    for _, item in ipairs(conceal_keywords) do
      local word, char = item[1], item[2]
      vim.cmd(string.format(
        "syntax keyword essenceNiceOperator %s conceal cchar=%s",
        word,
        char
      ))
    end

    -- Add match conceal rules
    for _, item in ipairs(conceal_matches) do
      local pattern, char = item[1], item[2]
      vim.cmd(string.format(
        "syntax match essenceNiceOperator '%s' conceal cchar=%s",
        pattern,
        char
      ))
    end

    -- Link highlight groups
    vim.cmd("highlight link essenceNiceOperator Operator")
    vim.cmd("highlight! link Conceal Operator")
  end)
end

-- Remove concealment syntax rules from the current buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
local function remove_conceal_syntax(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.cmd, "syntax clear essenceNiceOperator")
  end)
end

-- Enable concealment for a buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
function M.enable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  if not has_conceal_support() then
    vim.notify(
      "Concealing requires UTF-8 encoding and conceal support",
      vim.log.levels.WARN,
      { title = "essence.nvim" }
    )
    return false
  end

  -- Set buffer-local variable
  vim.b[bufnr].essence_conceal = true

  -- Apply syntax and set conceallevel
  apply_conceal_syntax(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.opt_local.conceallevel = 2
  end)

  return true
end

-- Disable concealment for a buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
function M.disable(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Set buffer-local variable
  vim.b[bufnr].essence_conceal = false

  -- Remove syntax and reset conceallevel
  remove_conceal_syntax(bufnr)
  vim.api.nvim_buf_call(bufnr, function()
    vim.opt_local.conceallevel = 0
  end)

  return true
end

-- Toggle concealment for a buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
---@return boolean New concealment state
function M.toggle(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local current_state = M.is_enabled(bufnr)

  if current_state then
    M.disable(bufnr)
    vim.notify("Concealment disabled", vim.log.levels.INFO, { title = "essence.nvim" })
    return false
  else
    local success = M.enable(bufnr)
    if success then
      vim.notify("Concealment enabled", vim.log.levels.INFO, { title = "essence.nvim" })
    end
    return success
  end
end

-- Check if concealment is enabled for a buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
---@return boolean
function M.is_enabled(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- Check buffer-local variable
  local buf_conceal = vim.b[bufnr].essence_conceal
  if buf_conceal ~= nil then
    return buf_conceal
  end

  -- Fall back to global config
  local essence = require("essence")
  return essence.config.conceal or false
end

-- Enable concealment globally for all essence buffers
function M.enable_global()
  local essence = require("essence")
  essence.config.conceal = true

  -- Apply to all currently open essence buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == "essence" then
      -- Only apply if no buffer-local override
      if vim.b[bufnr].essence_conceal == nil then
        M.enable(bufnr)
      end
    end
  end

  vim.notify("Concealment enabled globally", vim.log.levels.INFO, { title = "essence.nvim" })
  return true
end

-- Disable concealment globally for all essence buffers
function M.disable_global()
  local essence = require("essence")
  essence.config.conceal = false

  -- Remove from all currently open essence buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == "essence" then
      -- Only apply if no buffer-local override
      if vim.b[bufnr].essence_conceal == nil then
        M.disable(bufnr)
      end
    end
  end

  vim.notify("Concealment disabled globally", vim.log.levels.INFO, { title = "essence.nvim" })
  return true
end

-- Toggle concealment globally
---@return boolean New global concealment state
function M.toggle_global()
  local essence = require("essence")
  if essence.config.conceal then
    M.disable_global()
    return false
  else
    M.enable_global()
    return true
  end
end

-- Get concealment status for a buffer
---@param bufnr integer|nil Buffer number (nil for current buffer)
---@return table Status information
function M.status(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local essence = require("essence")
  local buf_enabled = M.is_enabled(bufnr)
  local has_override = vim.b[bufnr].essence_conceal ~= nil

  return {
    enabled = buf_enabled,
    has_buffer_override = has_override,
    global_setting = essence.config.conceal,
    conceallevel = vim.api.nvim_get_option_value("conceallevel", { buf = bufnr }),
    has_support = has_conceal_support(),
  }
end

return M

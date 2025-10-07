---@class LspConfig
---@field enabled boolean Enable LSP integration (default: true)
---@field cmd table|nil LSP server command (default: { "conjure", "lsp" })
---@field settings table|nil LSP server settings

local M = {}

---Check if a binary is executable
---@param binary string Binary name to check
---@return boolean
local function is_executable(binary)
  return vim.fn.executable(binary) == 1
end

---Check if a plugin is available/loaded
---@param plugin string Plugin name
---@return boolean
local function has_plugin(plugin)
  local ok, _ = pcall(require, plugin)
  return ok
end

---Check if lazy.nvim is being used as the package manager
---@return boolean
local function is_lazy_nvim()
  -- Check if lazy is available
  return has_plugin("lazy")
end

---Setup LSP configuration for essence
---@param config LspConfig LSP configuration
---@return boolean success Whether setup was successful
function M.setup(config)
  -- Default to enabled if not specified
  if config.enabled == false then
    return false
  end

  -- Check if nvim-lspconfig is installed
  if not has_plugin("lspconfig") then
    vim.notify("essence.nvim LSP: nvim-lspconfig not installed, skipping LSP setup", vim.log.levels.DEBUG)
    return false
  end

  -- TODO: Automatically download conjure binary if not present
  -- Check if conjure binary is available
  local cmd = config.cmd or { "conjure", "lsp" }
  local binary = cmd[1]

  if not is_executable(binary) then
    vim.notify(
      string.format(
        "essence.nvim LSP: '%s' binary not found in PATH, skipping LSP setup\n"
          .. "Please install conjure or set a custom command in config",
        binary
      ),
      vim.log.levels.WARN
    )
    return false
  end

  -- All checks passed, configure the LSP server
  local lspconfig = require("lspconfig")
  local configs = require("lspconfig.configs")

  -- Register essence_lsp if it's not already registered
  if not configs.essence_lsp then
    configs.essence_lsp = {
      default_config = {
        cmd = cmd,
        filetypes = { "essence" },
        single_file_support = true,
        settings = config.settings or {},
      },
    }
  end

  -- Setup the LSP server
  lspconfig.essence_lsp.setup(config.settings or {})

  return true
end

return M

---@class LspConfig
---@field enabled boolean Enable LSP integration (default: true)
---@field cmd table|nil LSP server command (default: { "conjure", "lsp" })
---@field settings table|nil LSP server settings

local M = {}

---Setup LSP using vim.lsp.config API (Neovim 0.11+)
---@param cmd table Command to run the LSP server
---@param settings table Server settings
---@return boolean success Whether setup was successful
local function setup_vimlsp(cmd, settings)
  vim.lsp.config("essence_lsp", {
    cmd = cmd,
    filetypes = { "essence" },
    root_markers = { ".git" },
    single_file_support = true,
    settings = settings,
  })

  vim.lsp.enable("essence_lsp")
  return true
end

---Setup LSP using lspconfig API (Neovim < 0.11)
---@param cmd table Command to run the LSP server
---@param settings table Server settings
---@return boolean success Whether setup was successful
local function setup_lspconfig(cmd, settings)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok then
    vim.notify("essence.nvim LSP: nvim-lspconfig not installed, skipping LSP setup", vim.log.levels.DEBUG)
    return false
  end

  local configs = require("lspconfig.configs")
  local util = require("lspconfig.util")

  -- Register essence_lsp if it's not already registered
  if not configs.essence_lsp then
    configs.essence_lsp = {
      default_config = {
        cmd = cmd,
        filetypes = { "essence" },
        single_file_support = true,
        root_dir = function(fname)
          -- Use LazyVim's root detection if available
          if _G.LazyVim and _G.LazyVim.root and _G.LazyVim.root.git then
            return _G.LazyVim.root.git()
          end
          -- Fallback to lspconfig util root_pattern
          return util.root_pattern(".git")(fname) or vim.fs.dirname(fname)
        end,
        settings = settings,
      },
    }
  end

  lspconfig.essence_lsp.setup(settings)
  return true
end

---Setup LSP configuration for essence
---@param config LspConfig LSP configuration
---@return boolean success Whether setup was successful
function M.setup(config)
  -- Default to enabled if not specified
  if config.enabled == false then
    return false
  end

  -- TODO: Automatically download conjure binary if not present
  local cmd = config.cmd or { "conjure", "lsp" }
  local binary = cmd[1]

  -- Check if conjure binary is available
  if vim.fn.executable(binary) ~= 1 then
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

  local settings = config.settings or {}

  -- Use vim.lsp.config API for Neovim 0.11+, fallback to lspconfig for older versions
  if vim.lsp.config then
    return setup_vimlsp(cmd, settings)
  else
    return setup_lspconfig(cmd, settings)
  end
end

return M

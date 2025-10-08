-- after/ftplugin/essence.lua
-- Filetype plugin for Essence and Essence' modelling languages

-- Prevent loading file twice
if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = 1

-- Set comment string ($ is the comment character in Essence)
vim.bo.commentstring = "$ %s"

-- Configure comment continuation
vim.bo.comments = "b:$"
vim.bo.formatoptions = vim.bo.formatoptions .. "ro"

-- Enable autoindent
vim.bo.autoindent = true

-- Set up undo for buffer-local options
vim.b.undo_ftplugin = "setlocal commentstring< comments< formatoptions< autoindent<"

-- Apply concealment settings
-- This respects both global config and buffer-local overrides
local function apply_concealment()
  -- Only proceed if essence module is available
  local ok, essence = pcall(require, "essence")
  if not ok then
    return
  end

  -- Check if we should enable concealment for this buffer
  local conceal_module = require("essence.conceal")
  if conceal_module.is_enabled() then
    conceal_module.enable()
  end
end

-- Apply concealment after a short delay to ensure syntax is loaded
vim.defer_fn(apply_concealment, 10)

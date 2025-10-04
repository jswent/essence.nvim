-- after/ftplugin/essence.lua
-- Filetype plugin for Essence and Essence' modelling languages

-- Prevent loading file twice
if vim.b.did_ftplugin then
  return
end
vim.b.did_ftplugin = 1

-- Set comment string ($ is the comment character in Essence)
vim.bo.commentstring = "$ %s"

-- Enable autoindent
vim.bo.autoindent = true

-- Set up undo for buffer-local options
vim.b.undo_ftplugin = "setlocal commentstring< autoindent<"

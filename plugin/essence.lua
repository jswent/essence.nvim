-- plugin/essence.lua
-- Auto-initialization for essence.nvim

if vim.g.loaded_essence then
  return
end
vim.g.loaded_essence = 1

-- Setup user commands
require("essence.commands").setup()

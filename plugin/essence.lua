-- plugin/essence.lua
-- Auto-initialization for essence.nvim

if vim.g.loaded_essence then
  return
end
vim.g.loaded_essence = 1

-- Plugin is loaded via filetype detection and syntax files
-- No eager initialization needed

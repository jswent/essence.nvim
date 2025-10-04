-- lua/essence/commands.lua
-- User commands for essence.nvim

local M = {}

---Setup user commands
function M.setup()
  -- Buffer-local commands
  vim.api.nvim_create_user_command("EssenceConcealToggle", function()
    require("essence").conceal_toggle()
  end, {
    desc = "Toggle concealment for current buffer",
  })

  vim.api.nvim_create_user_command("EssenceConcealEnable", function()
    require("essence").conceal_enable()
  end, {
    desc = "Enable concealment for current buffer",
  })

  vim.api.nvim_create_user_command("EssenceConcealDisable", function()
    require("essence").conceal_disable()
  end, {
    desc = "Disable concealment for current buffer",
  })

  -- Global commands
  vim.api.nvim_create_user_command("EssenceConcealToggleGlobal", function()
    require("essence").conceal_toggle_global()
  end, {
    desc = "Toggle concealment globally for all essence buffers",
  })

  vim.api.nvim_create_user_command("EssenceConcealEnableGlobal", function()
    require("essence").conceal_enable_global()
  end, {
    desc = "Enable concealment globally for all essence buffers",
  })

  vim.api.nvim_create_user_command("EssenceConcealDisableGlobal", function()
    require("essence").conceal_disable_global()
  end, {
    desc = "Disable concealment globally for all essence buffers",
  })

  -- Status command
  vim.api.nvim_create_user_command("EssenceConcealStatus", function()
    local status = require("essence").conceal_status()

    local lines = {
      "Essence Concealment Status:",
      "",
      string.format("  Buffer concealment: %s", status.enabled and "enabled" or "disabled"),
      string.format("  Buffer override: %s", status.has_buffer_override and "yes" or "no"),
      string.format("  Global setting: %s", status.global_setting and "enabled" or "disabled"),
      string.format("  Conceal level: %d", status.conceallevel),
      string.format("  Has support: %s", status.has_support and "yes" or "no"),
    }

    vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "essence.nvim" })
  end, {
    desc = "Show concealment status for current buffer",
  })
end

return M

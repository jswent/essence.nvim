-- ftdetect/essence.lua
-- Filetype detection for Essence and Essence' modelling languages

vim.filetype.add({
  extension = {
    essence = "essence",
    eprime = "essence",
    param = "essence",
    rule = "essence",
    repr = "essence",
    solution = "essence",
  },
  pattern = {
    -- Match files with .essence.out, .essence.log, .essence.err extensions
    [".*%.essence%.out"] = "essence",
    [".*%.essence%.log"] = "essence",
    [".*%.essence%.err"] = "essence",

    -- Match files beginning with "language Essence" or "language ESSENCE"
    ["^language [Ee][Ss][Ss][Ee][Nn][Cc][Ee].*"] = {
      priority = -math.huge,
      function(path, bufnr)
        local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if first_line:match("^language [Ee][Ss][Ss][Ee][Nn][Cc][Ee]") then
          return "essence"
        end
      end,
    },
  },
})

-- Additional content-based detection for files without recognized extensions
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  callback = function(args)
    -- Skip if filetype is already set
    if vim.bo[args.buf].filetype ~= "" then
      return
    end

    -- Check if first line starts with "language Essence" or "language ESSENCE"
    local first_line = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
    if first_line:match("^language [Ee][Ss][Ss][Ee][Nn][Cc][Ee]") then
      vim.bo[args.buf].filetype = "essence"
    end
  end,
})

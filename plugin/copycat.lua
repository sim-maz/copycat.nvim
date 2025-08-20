local copycat = require("copycat")

vim.api.nvim_create_user_command("CopycatRelativePath", function()
  copycat.copy_relative_path()
end, {})

vim.api.nvim_create_user_command("CopycatAbsolutePath", function()
  copycat.copy_absolute_path()
end, {})

vim.api.nvim_create_user_command("CopycatPrefixedPath", function()
  copycat.copy_prefixed_path()
end, {})

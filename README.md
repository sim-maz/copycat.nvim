# copycat.nvim

A Neovim plugin to copy file paths with extra features.

## Features

- Copy relative file path.
- Copy absolute file path.
- Copy file path with a prefix (e.g., GitHub repository URL).
- Automatically detects Git repository URL.
- Configurable custom repository URL.
- Notifications on copy.
- Optional support for `mini.notify`.

## Installation

### lazy.nvim

```lua
{
  "sim-maz/copycat.nvim",
  config = function()
    require("copycat").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
    })
  end,
}
```

## Configuration

The `setup` function accepts a table with the following options:

- `custom_repo_url` (string, optional): A custom repository URL to use as a prefix. If not provided, the plugin will try to get it from the git remote configuration.
- `notification_plugin` (string, optional): The notification plugin to use. Can be `"vim.notify"` (default) or `"mini.notify"`.
- `notification_timeout` (number, optional): Timeout in milliseconds for notifications. Defaults to `10000` (10 seconds).

Example:

```lua
require("copycat").setup({
  custom_repo_url = "https://my-custom-git-host.com/my-repo",
  notification_plugin = "mini.notify",
  notification_timeout = 5000, -- 5 seconds
})
```

## Usage

The plugin exposes the following commands:

- `:CopycatRelativePath`: Copies the relative path of the current file.
- `:CopycatAbsolutePath`: Copies the absolute path of the current file.
- `:CopycatPrefixedPath`: Copies the relative path of the current file prefixed with the Git repository URL.

You can create keymaps for these commands in your Neovim configuration:

```lua
vim.keymap.set("n", "<leader>cr", "<cmd>CopycatRelativePath<cr>", { desc = "Copycat: Relative Path" })
vim.keymap.set("n", "<leader>ca", "<cmd>CopycatAbsolutePath<cr>", { desc = "Copycat: Absolute Path" })
vim.keymap.set("n", "<leader>cp", "<cmd>CopycatPrefixedPath<cr>", { desc = "Copycat: Prefixed Path" })
```

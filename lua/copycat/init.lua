-- Main plugin file for copycat
local M = {}

local config = {
  custom_repo_url = nil,
  notification_plugin = "vim.notify", -- "mini.notify" or "vim.notify"
  notification_timeout = 10000,
}

local function get_level_key(level_value)
    for key, value in pairs(vim.log.levels) do
        if value == level_value then
            return key
        end
    end
    return "INFO" -- fallback
end

local function notify(message, level)
  level = level or vim.log.levels.INFO
  local opts = { timeout = config.notification_timeout }
  if config.notification_plugin == "mini.notify" then
    local success, mini_notify = pcall(require, "mini.notify")
    if success and mini_notify then
      local level_key = get_level_key(level)
      mini_notify.add(message, level_key, opts)
      return
    end
  end
  vim.notify(message, level, opts)
end

local function copy_to_clipboard(text)
  vim.fn.setreg("+", text)
  notify("Copied: " .. text)
end

local function get_relative_path()
  return vim.fn.expand("%:p:~:.")
end

local function get_absolute_path()
  return vim.fn.expand("%:p")
end

local function get_git_repo_url()
  if config.custom_repo_url then
    return config.custom_repo_url
  end

  local remote_cmd = "git config --get remote.origin.url"
  local remote = vim.fn.system(remote_cmd):gsub("\n", "")
  if vim.v.shell_error ~= 0 then
    notify("Could not get git remote URL.", vim.log.levels.ERROR)
    return nil
  end

  if remote:match("^git@") then
    local host, path = remote:match("^git@([^:]+):(.+)")
    if host and path then
      remote = "https://" .. host .. "/" .. path
    end
  end

  if remote:match("%.git$") then
    remote = remote:gsub("%.git$", "")
  end

  return remote
end

local function get_git_branch()
    local branch_cmd = "git rev-parse --abbrev-ref HEAD"
    local branch = vim.fn.system(branch_cmd):gsub("\n", "")
    if vim.v.shell_error ~= 0 then
        notify("Could not get current git branch, falling back to 'master'.", vim.log.levels.WARN)
        return "master" -- fallback to master
    end
    return branch
end

function M.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})
end

function M.copy_relative_path()
  local path = get_relative_path()
  if path == "" then
    notify("No file name to copy.", vim.log.levels.WARN)
    return
  end
  copy_to_clipboard(path)
end

function M.copy_absolute_path()
  local path = get_absolute_path()
  if path == "" then
    notify("No file name to copy.", vim.log.levels.WARN)
    return
  end
  copy_to_clipboard(path)
end

function M.copy_prefixed_path()
  local repo_url = get_git_repo_url()
  if not repo_url then
    return
  end

  local relative_path = get_relative_path()
  if relative_path == "" then
    notify("No file name to copy.", vim.log.levels.WARN)
    return
  end

  local branch = get_git_branch()
  local line_nr = vim.fn.line(".")

  local file_url = repo_url .. "/blob/" .. branch .. "/" .. relative_path .. "#L" .. line_nr
  copy_to_clipboard(file_url)
end

return M

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  checker = { enabled = false },
})

-- Auto-update plugins on startup, notify only if updates occurred
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      require("lazy").update({ show = false })
    end, 0)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyUpdate",
  callback = function(ev)
    local updated = {}
    for _, plugin in pairs(ev.data and ev.data.plugins or {}) do
      if plugin._.updated then
        table.insert(updated, plugin.name)
      end
    end
    if #updated > 0 then
      vim.notify(
        "Updated " .. #updated .. " plugin(s): " .. table.concat(updated, ", "),
        vim.log.levels.INFO,
        { title = "lazy.nvim" }
      )
    end
  end,
})

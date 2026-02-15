if vim.loader then
  vim.loader.enable()
end

require('options')
require('keymaps')
require('commands')




-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'cs',
  callback = function()
    vim.schedule(function()
      vim.keymap.set('n', '<leader>b', function()
        require('easy-dotnet').build_default_quickfix()
      end)
    end)
  end,
})


-- annoying until can move the box
-- vim.api.nvim_create_autocmd('CursorHold', {
--   callback = function()
--     vim.diagnostic.open_float(nil, {
--       focusable = false,
--       scope = 'line',
--       border = 'rounded',
--     })
--   end,
-- })


-- INFO:Lazy Install
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- INFO:Plugins
require('lazy').setup(

  { import = 'plugins' },
{
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

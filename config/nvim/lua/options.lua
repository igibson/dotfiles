vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.termguicolors = true

vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

vim.opt.mouse = 'a'

vim.opt.cmdheight = 0
vim.opt.showmode = false

vim.opt.clipboard = 'unnamedplus'

vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.inccommand = 'split'

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 15

vim.g.undotree_DiffCommand = 'FC'

vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

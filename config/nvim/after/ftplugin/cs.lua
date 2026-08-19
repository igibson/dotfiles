vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

--use treesitter for indent
-- vim.opt_local.autoindent = true
-- vim.opt_local.smartindent = true
vim.opt_local.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt_local.foldlevel = 99

vim.treesitter.start()

local function close_quickfix()
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end
end

vim.keymap.set("n", "<leader>b", function()
  vim.cmd("write")
  close_quickfix()
  require("easy-dotnet").build_default_quickfix()
end, { buffer = true, desc = "Build project" })

vim.keymap.set("n", "<leader>fo", function()
  vim.wo.foldlevel = 1
  vim.cmd("normal! zz")
end, { buffer = true, desc = "Fold to outline" })

vim.keymap.set("n", "<leader>fm", function()
  vim.wo.foldlevel = vim.wo.foldlevel == 99 and 2 or 99
  vim.cmd("normal! zz")
end, { buffer = true, desc = "Toggle method folds" })

vim.keymap.set("n", "<leader>fu", function()
  vim.wo.foldlevel = 99
  vim.cmd("normal! zz")
end, { buffer = true, desc = "Unfold all" })

vim.keymap.set("n", "<leader>fv", "zMzvzz", {
  buffer = true,
  desc = "Focus current method",
})

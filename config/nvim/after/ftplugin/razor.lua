vim.treesitter.start()

vim.keymap.set("n", "<leader>b", function()
  vim.cmd("write")
  require("easy-dotnet").build_default_quickfix()
end, { buffer = true, desc = "Build project" })

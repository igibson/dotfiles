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

vim.keymap.set("i", "<C-s>", "<cmd>LspOverloads signature<CR>", { buffer = true })

-- INFO: Custom handling for lsp overloads plugin
local function lsp_overloads_jump_to_args_list_then_show()
  local ts = vim.treesitter
  local node = ts.get_node()

  -- Walk up to check if we're already in an argument list
  local cur = node
  while cur do
    if cur:type():match("argument") then
      -- Already inside an argument list
      vim.cmd("LspOverloads signature")
      return
    end
    cur = cur:parent()
  end

  -- Not in an argument list — search forward for the nearest one
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2] -- 0-indexed

  local root = ts.get_parser(bufnr):parse()[1]:root()
  local lang = ts.language.get_lang(vim.bo.filetype) or vim.bo.filetype
  local query = ts.query.parse(lang, "(argument_list) @args")

  local best = nil
  for _, match_node, _ in query:iter_captures(root, bufnr) do
    local sr, sc = match_node:start()
    -- Only consider nodes that start after the cursor
    if sr > row or (sr == row and sc > col) then
      if not best then
        best = match_node
      else
        local br, bc = best:start()
        if sr < br or (sr == br and sc < bc) then
          best = match_node
        end
      end
    end
  end

  if best then
    local sr, sc = best:start()
    -- Place cursor right after the opening paren
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc + 1 })
    vim.cmd("LspOverloads signature")
  end
end

local function lsp_overloads_show_in_insert_mode()
  -- use treesitter to detect argument list and show sig helper if going into insert mode in function args
  local node = vim.treesitter.get_node()
  local depth = 0
  while node and depth < 10 do
    if node:type() == "argument_list" then
      vim.defer_fn(function()
        vim.cmd("LspOverloads signature")
      end, 50)
      return
    end
    node = node:parent()
    depth = depth + 1
  end
end

vim.keymap.set(
  "n",
  "<C-s>",
  lsp_overloads_jump_to_args_list_then_show,
  { desc = "Jump to next arg list and show LSP overloads" }
)

vim.api.nvim_create_autocmd("InsertEnter", {
  buffer = 0,
  callback = lsp_overloads_show_in_insert_mode,
})

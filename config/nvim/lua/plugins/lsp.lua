--INFO: Enforce canonical paths for lsp roots to prevent mulitple LspAttach

-- INFO: LSP configuration functions
local function setup_lsp(client, event)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight-" .. event.buf, {})

    -- Highlight references under cursor
    vim.api.nvim_create_autocmd({ "CursorHold" }, {
      group = group,
      buffer = event.buf,
      callback = vim.lsp.buf.document_highlight,
    })

    -- Clear highlights when cursor moves
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
      group = group,
      buffer = event.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end

  -- NEW CODE (compliant with 0.12)
  if vim.lsp.codelens and vim.lsp.codelens.enable then
    vim.lsp.codelens.enable(false, { bufnr = event.buf })
  end

  -- if vim.lsp.inlay_hint then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
  -- end
end

local function setup_lsp_keymaps(event)
  local map = function(keys, func, desc)
    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
  end

  map("<leader>th", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, "Toggle Inlay Hints")

  map("gd", require("snacks").picker.lsp_definitions, "[G]oto [D]efinition")
  map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  vim.keymap.set(
    { "n", "v" },
    "<leader>ca",
    vim.lsp.buf.code_action,
    { buffer = event.buf, desc = "LSP: [C]ode [A]ction" }
  )
  map("K", vim.lsp.buf.hover, "Hover Documentation")
  map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
end

local function lspAttach(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end

  local bufnr = event.buf
  -- if vim.bo[bufnr].filetype == "razor" then
  --   vim.lsp.stop_client(client.id)
  --   return
  -- end

  setup_lsp(client, event)
  setup_lsp_keymaps(event)
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "saghen/blink.nvim",
    -- 'folke/snacks.nvim',
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", { callback = lspAttach })

    vim.lsp.config("lua_ls", {
      settings = { Lua = { completion = { callSnippet = "Replace" } } },
    })

    require("mason").setup({
      registries = {
        "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
      },
    })

    require("mason-lspconfig").setup()
    require("mason-tool-installer").setup({
      ensure_installed = { "lua_ls", "stylua" },
    })
  end,
}

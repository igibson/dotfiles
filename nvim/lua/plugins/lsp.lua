-- INFO: Custom handling for lsp overloads plugin
local function lsp_overloads_jump_to_args_list_then_show()
  local ts = vim.treesitter
  local node = ts.get_node()

  -- Walk up to check if we're already in an argument list
  local cur = node
  while cur do
    if cur:type():match 'argument' then
      -- Already inside an argument list
      vim.cmd 'LspOverloadsSignature'
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
  local query = ts.query.parse(lang, '(argument_list) @args')

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
    vim.cmd 'LspOverloadsSignature'
  end
end


local function lsp_overloads_show_in_insert_mode()
  -- use treesitter to detect argument list and show sig helper if going into insert mode in function args
  local node = vim.treesitter.get_node()
  local depth = 0
  while node and depth < 10 do
    if node:type() == 'argument_list' then
      vim.defer_fn(function()
        vim.cmd 'LspOverloadsSignature'
      end, 50)
      return
    end
    node = node:parent()
    depth = depth + 1
  end
end


-- INFO: LSP configuration functions 
local function setup_lsp(client, event)
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup('LspDocumentHighlight-' .. event.buf, {})

      -- Highlight references under cursor
      vim.api.nvim_create_autocmd({ 'CursorHold' }, {
        group = group,
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      -- Clear highlights when cursor moves
      vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
        group = group,
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end


    if vim.lsp.codelens and vim.lsp.codelens.enable then
      vim.lsp.codelens.enable(false, event.buf)
    end

    if vim.lsp.inlay_hint then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end
end


local function setup_lsp_overloads(client, event)
    if client.server_capabilities.signatureHelpProvider then
      require('lsp-overloads').setup(client, {
        ui = {
          border = 'single',
          floating_window_above_cur_line = true,
          offset_x = 0,
          offset_y = 0,
          max_height = 10,
          max_width = 400,
          wrap = true,
        },
        keymaps = {
          next_signature = '<C-j>',
          previous_signature = '<C-k>',
          next_parameter = '<C-l>',
          previous_parameter = '<C-h>',
          close_signature = '<C-e>',
        },
      })

      vim.keymap.set('i', '<C-s>', '<cmd>LspOverloadsSignature<CR>', { buffer = event.buf })
      -- vim.keymap.set('n', '<C-s>', '<cmd>LspOverloadsSignature<CR>', { buffer = event.buf, desc = 'Signature Help' })

      vim.keymap.set('n', '<C-s>', lsp_overloads_jump_to_args_list_then_show, { desc = 'Jump to next arg list and show LSP overloads' })

      vim.api.nvim_create_autocmd('InsertEnter', {
        buffer = event.buf,
        callback = lsp_overloads_show_in_insert_mode,
      })
    end
end


local function setup_lsp_keymaps(event)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  map('<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, 'Toggle Inlay Hints')

  map('gd', require('snacks').picker.lsp_definitions, '[G]oto [D]efinition')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = event.buf, desc = 'LSP: [C]ode [A]ction' })
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end


local function lspAttach(event)
  vim.notify("lsp attached")
  print("lsp attached")

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client then
    return
  end

  setup_lsp(client, event)
  setup_lsp_overloads(client, event)
  setup_lsp_keymaps(event)
end



return
{
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'saghen/blink.nvim',
    -- 'seblyng/roslyn.nvim',
    -- 'folke/snacks.nvim',
    { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
  },
  config = function()

    vim.api.nvim_create_autocmd('LspAttach', { callback = lspAttach })

    vim.lsp.config('lua_ls', {
      settings = { Lua = { completion = { callSnippet = 'Replace' } } },
    })

    vim.lsp.config('roslyn', {
      settings = {
        ['csharp|inlay_hints'] = {
          csharp_enable_inlay_hints_for_implicit_object_creation = true,
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          csharp_enable_inlay_hints_for_lambda_parameter_types = true,
          csharp_enable_inlay_hints_for_types = true,
          dotnet_enable_inlay_hints_for_indexer_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_enable_inlay_hints_for_object_creation_parameters = true,
          dotnet_enable_inlay_hints_for_other_parameters = true,
          dotnet_enable_inlay_hints_for_parameters = true,
        },
        ['csharp|code_lens'] = {
          dotnet_enable_references_code_lens = false,
        },
      },
    })

    require('mason').setup {
      registries = {
        'github:Crashdummyy/mason-registry',
        'github:mason-org/mason-registry',
      },
    }

    require('mason-lspconfig').setup()
    require('mason-tool-installer').setup {
      ensure_installed = { 'lua_ls', 'roslyn', 'stylua' },
    }
  end,
}

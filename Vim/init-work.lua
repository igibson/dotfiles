if vim.loader then
  vim.loader.enable()
end

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

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Set highlight on search, but clear on pressing <Esc> in normal mode' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

local function toggle_quickfix()
  local windows = vim.fn.getwininfo()
  for _, win in pairs(windows) do
    if win['quickfix'] == 1 then
      vim.cmd.cclose()
      return
    end
  end
  vim.cmd.copen()
end

vim.keymap.set('n', '<Leader>q', toggle_quickfix, { desc = '[Q]uickfix Window' })

vim.keymap.set('n', '<A-h>', '<cmd>colder<return>')
vim.keymap.set('n', '<A-j>', '<Cmd>try | cnext | catch | cfirst | catch | endtry<CR>')
vim.keymap.set('n', '<A-k>', '<Cmd>try | cprevious | catch | clast | catch | endtry<CR>')
vim.keymap.set('n', '<A-l>', '<cmd>cnewer<return>')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

function split_line_below_and_stay_put()
  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]

  -- Insert a blank line below the current line, with strict indexing
  vim.api.nvim_buf_set_lines(0, row, row, false, { '' })
end

function new_line_above_and_stay_put()
  local current_col = vim.fn.col '.'

  -- Exit insert mode temporarily
  vim.api.nvim_input '<Esc>'

  -- Insert a new blank line above the current one
  vim.api.nvim_command 'normal! O'

  -- Go back to the original line and restore the cursor column
  vim.api.nvim_command 'normal! j' -- Move down to the original line
  vim.fn.cursor(0, current_col) -- Restore the column

  -- Re-enter insert mode at the original position
  vim.api.nvim_input 'a'
end

vim.keymap.set('i', '<C-CR>', split_line_below_and_stay_put, { desc = 'Insert: Split line below, stay on current' })
vim.keymap.set('i', '<S-CR>', new_line_above_and_stay_put, { desc = 'Insert: New line above, stay on current' })

vim.keymap.set('n', '<F13>', '<C-I>', { noremap = true, silent = true, desc = 'Remap ctrl i to F13, requires a key redirect mapping in terminal emulator' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move highlight up in visual mode' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move highlight down in visual mode' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join line from below without moving cursor' })

vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page jump down keep cursor centered' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page jump up keep cursor centered' })
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
--quick fix and center screen
-- vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz')
-- vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz')

vim.keymap.set('n', 'k', [[(v:count > 1 ? "m'" . v:count : "g") . 'k']], { expr = true, desc = 'Add relative jumps to the jumplist' })
vim.keymap.set('n', 'j', [[(v:count > 1 ? "m'" . v:count : "g") . 'j']], { expr = true, desc = 'Add relative jumps to the jumplist' })

--yank/put workflow
vim.keymap.set('v', '<leader>p', '"0p', { remap = false, desc = 'Put last yanked text.' })
vim.keymap.set('n', '<Del>', 'diw', { noremap = true, desc = 'Delete word under cursor to black hole register' })
vim.keymap.set('n', '<BS>', 'ciw', { noremap = true, desc = 'Change word under to black hole register' })
vim.keymap.set('v', 'p', 'P', { noremap = true, desc = 'Put without clobbering yank register' })
vim.keymap.set('v', 'P', 'p', { noremap = true, desc = 'Put and overwrite yank register' })
vim.keymap.set('n', 's', '"_ciw<c-r>"<Esc>', { remap = false, desc = 'Replace' })
vim.keymap.set('n', 'S', '""ciw<c-r>"<Esc>', { remap = false, desc = 'Replace and Cut' })
vim.keymap.set({ 'n', 'v' }, '<leader>gy', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>gp', '"+p', { desc = 'Put from clipboard' })
--force some operations to use black hold register
vim.keymap.set('n', 'cc', '"_cc', { noremap = true, desc = 'Change to blackhole' })
vim.keymap.set('n', 'x', '"_x', { noremap = true, desc = 'Delete char to blackhole' })
vim.keymap.set('n', 'X', 'diw', { noremap = true, desc = 'Cut word' })

--delete into unamed
--first attempt, d and c commands will clobber unnamed
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])
-- --paste from last yanked
-- vim.keymap.set({ 'n', 'v' }, '<leader>p', '"0p')
--
-- --visual mode paste without changing yank register, although not consistent with other put behavior, potentially add s for substitue to preserve register, del for raw delete, leader d for delete, put will put with cut and x will also cut
-- -- vim.keymap.set('x', 'p', 'P', { remap = false, desc = 'Visual paste without clobbering yank register' })
-- -- maintain current put, put replaces and yanks, s replaces without yanking, add leader s which will replace with last yank
-- vim.keymap.set('x', '<Leader>p', '"0P', { desc = 'Paste without clobbering unnamed register' })
-- vim.keymap.set('x', '<Leader>P', '"_d"0P', { desc = 'Paste without clobbering unnamed register (before selection)' })
--

--global put and yank

--source control
vim.keymap.set('n', '<leader>sca', ':Vp4Add <cr>', { desc = 'Perforce add to source control' })
vim.keymap.set('n', '<leader>sce', ':Vp4Edit <cr>', { desc = 'Perforce open for edit in source control' })
vim.keymap.set('n', '<leader>scc', ':Vp4Change <cr>', { desc = 'Opens the change specification in a new split.' })
vim.keymap.set('n', '<leader>scd', ':Vp4Diff <cr>', { desc = 'Diff file against checked out revision.' })
vim.keymap.set('n', '<leader>scr', ':Vp4Reopen <cr>', { desc = 'Move the current file to a different changelist.' })
vim.keymap.set('n', '<leader>scz', ':Vp4Annotate <cr>', { desc = 'Perforce open for edit in source control' })

vim.keymap.set('n', '<leader>p4a', ':P4Add<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p4e', ':P4Checkout<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p4r', ':P4Revert<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p4t', ':P4CheckedInTelescope<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>pm', ':P4MoveRename<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pg', ':P4GetFileCL<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ph', ':P4ShowFileHistory<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pl', ':P4MoveToChangelist<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pd', ':P4DeleteChangelist<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ps', ':P4ShowCheckedOut<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pc', ':P4CLList<CR>', { noremap = true, silent = true })

vim.keymap.set('n', 'Q', '<nop>')

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

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('Highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

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

      vim.keymap.set('n', '<C-s>', function()
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
      end, { desc = 'Jump to next arg list and show LSP overloads' })

      -- use treesitter to detect argument list and show sig helper if going into insert mode in function args
      vim.api.nvim_create_autocmd('InsertEnter', {
        buffer = event.buf,
        callback = function()
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
        end,
      })
    end

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
  end,
})

-- INFO:Lazy Install
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- INFO:Plugins
require('lazy').setup({
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'kwkarlwang/bufjump.nvim',
    config = function()
      require('bufjump').setup {
        forward_key = '<Tab>',
        backward_key = '<s-Tab>',
      }
    end,
  },
  { 'Issafalcon/lsp-overloads.nvim' },
  { 'RobertCWebb/vim-jumpmethod' },
  { 'seblj/roslyn.nvim' },
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'cs', 'vb', 'csproj', 'sln' },
    config = function()
      require('easy-dotnet').setup {
        lsp = {
          enabled = false,
        },
      }
    end,
  },
  {
    'khoido2003/roslyn-filewatch.nvim',
    ft = 'cs',
    config = function()
      require('roslyn_filewatch').setup {
        -- Optional: you can tell it to ignore heavy folders to keep it fast
        ignore_dirs = { 'Library', 'Temp', 'Obj', 'Bin', '.git', '.idea', '.vs', '.godot', '.mono', 'node_modules' },
      }
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion', 'Avante' },
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- TODO: Check icons
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-icons' }, -- if you prefer nvim-web-devicons
  },
  { 'ngemily/vim-vp4', event = 'VeryLazy' },
  { 'motiongorilla/p4nvim', event = 'VeryLazy' },
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },
  {
    'stevearc/oil.nvim',
    event = 'VeryLazy',
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    keys = {
      {
        '[x',
        function()
          require('treesitter-context').go_to_context()
        end,
      },
    },
    opts = {},
    -- Optional dependencies
    -- dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'hat0uma/csvview.nvim',
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        -- NOTE: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      spec = {
        { '<leader>c', group = '[C]ode' },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Combines both modes here
      },
    },
  },
  -- {
  --     'folke/which-key.nvim',
  --     event = 'VimEnter',
  --     config = function()
  --       require('which-key').setup()
  --       require('which-key').register {
  --         ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  --         ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  --         ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  --         ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  --         ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
  --         ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
  --         ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
  --       }
  --       require('which-key').register({
  --         ['<leader>h'] = { 'Git [H]unk' },
  --       }, { mode = 'v' })
  --     end,
  --   },
  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
    },
    -- stylua: ignore
    keys = {
      { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers', },
      { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep', },
      { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History', },
      { '<leader><space>', function() Snacks.picker.files() end, desc = 'Find Files', },
      -- find
      { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers', },
      { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File', },
      { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files', },
      { '<leader>fg', function() Snacks.picker.git_files() end, desc = 'Find Git Files', },
      { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent', },
      -- git
      { '<leader>gc', function() Snacks.picker.git_log() end, desc = 'Git Log', },
      { '<leader>gs', function() Snacks.picker.git_status() end, desc = 'Git Status', },
      -- Grep
      { '<leader>sb', function() Snacks.picker.lines() end, desc = 'Buffer Lines', },
      { '<leader>sB', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers', },
      { '<leader>sg', function() Snacks.picker.grep() end, desc = 'Grep', }, 
      { '<leader>sw', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' }, },
      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = 'Registers', },
      { '<leader>sa', function() Snacks.picker.autocmds() end, desc = 'Autocmds', },
      { '<leader>sc', function() Snacks.picker.command_history() end, desc = 'Command History', },
      { '<leader>sC', function() Snacks.picker.commands() end, desc = 'Commands', },
      { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Diagnostics', },
      { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages', },
      { '<leader>sH', function() Snacks.picker.highlights() end, desc = 'Highlights', },
      { '<leader>sj', function() Snacks.picker.jumps() end, desc = 'Jumps', },
      { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
      { '<leader>sl', function() Snacks.picker.loclist() end, desc = 'Location List', },
      { '<leader>sM', function() Snacks.picker.man() end, desc = 'Man Pages', },
      { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks', },
      { '<leader>sR', function() Snacks.picker.resume() end, desc = 'Resume', },
      { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List', },
      { '<leader>uC', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes', },
      { '<leader>qp', function() Snacks.picker.projects() end, desc = 'Projects', },
      -- LSP
      { 'gd', function() Snacks.picker.lsp_definitions() end, desc = 'Goto Definition', },
      { 'gr', function() Snacks.picker.lsp_references() end, nowait = true, desc = 'References', },
      { 'gI', function() Snacks.picker.lsp_implementations() end, desc = 'Goto Implementation', }, 
      { 'gy', function() Snacks.picker.lsp_type_definitions() end, desc = 'Goto T[y]pe Definition', },
      { '<leader>ss', function() Snacks.picker.lsp_symbols() end, desc = 'LSP Symbols', },
      { '<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', },
      { '<leader>wt', function() Snacks.picker.lsp_workspace_symbols({ filter = { default = { 'Class', 'Interface', 'Struct', 'Enum' } } }) end, desc = 'Workspace Types' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim' },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.nvim',
      -- 'seblyng/roslyn.nvim',
      { 'folke/lazydev.nvim', ft = 'lua', opts = {} },
      -- 'folke/snacks.nvim',
    },
    config = function()
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
  },
  {
    'stevearc/conform.nvim',
    lazy = false,
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        -- javascript = { { "prettierd", "prettier" } },
      },
    },
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = { 'saghen/blink.nvim' },
    opts = {
      fuzzy = {
        implementation = 'prefer_rust',
      },
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'select_and_accept', 'fallback' },
      },
      signature = {
        enabled = false,
      },
      completion = {
        ghost_text = {
          enabled = false,
        },
        menu = {
          auto_show = true,
          direction_priority = { 's' },
          draw = {
            components = {
              kind_icon = {
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
              kind = {
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = false,
        },
      },
    },
  },
  -- {
  --   'metalelf0/black-metal-theme-neovim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('black-metal').setup {
  --       -- Can be one of: bathory | burzum | dark-funeral | darkthrone | emperor | gorgoroth | immortal | impaled-nazarene | khold | marduk | mayhem | nile | taake | thyrfing | venom | windir
  --       theme = 'dark-funeral',
  --       -- Can be one of: 'light' | 'dark', or set via vim.o.background
  --       variant = 'dark',
  --       -- Use an alternate, lighter bg
  --       alt_bg = true,
  --       -- variant = 'light',
  --       -- optional configuration here
  --     }
  --     require('black-metal').load()
  --     -- vim.cmd.colorscheme = 'burzam-alt'
  --   end,
  -- },
  { 'rose-pine/neovim', name = 'rose-pine' },

  { 'armannikoyan/rusty', name = 'rusty' },
  { 'AlexvZyl/nordic.nvim', name = 'nordic' },
  {
    'oskarnurm/koda.nvim',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- require("koda").setup({ transparent = true })
      vim.cmd 'colorscheme koda'
    end,
  },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      on_highlights = function(hl, c)
        -- Make method parameters white
        hl['@parameter'] = { fg = '#ffffff' }
        hl['@variable.parameter'] = { fg = '#ffffff' }

        -- Diagnostic underlines
        hl['DiagnosticUnderlineError'] = { underline = true, sp = '#db4b4b' }
        hl['DiagnosticUnderlineWarn'] = { underline = true, sp = '#e0af68' }
        hl['DiagnosticUnderlineInfo'] = { underline = true, sp = '#0db9d7' }
        hl['DiagnosticUnderlineHint'] = { underline = true, sp = '#10B981' }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [']quote
      --  - ci'  - [C]hange [I]nside [']quote
      local gen_spec = require('mini.ai').gen_spec
      require('mini.ai').setup {
        custom_textobjects = {
          -- Tweak argument to be recognized only inside `()` between `;`
          -- a = gen_spec.argument { brackets = { '%b()' }, separator = ';' },

          -- Tweak function call to not detect dot in function name
          -- f = gen_spec.function_call { name_pattern = '[%w_]' },

          -- Function definition (needs treesitter queries with these captures)
          F = gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          k = gen_spec.treesitter { a = '@assignment.outer', i = '@assignment.lhs' },

          -- Make `|` select both edges in non-balanced way
          -- ['|'] = gen_spec.pair('|', '|', { type = 'non-balanced' }),
        },
      }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      -- require('mini.surround').setup()

      -- require('mini.pairs').setup()
      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install { 'bash', 'c_sharp', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
  },

  -- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
  -- { import = 'custom.plugins' },
}, {
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

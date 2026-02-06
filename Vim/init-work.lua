vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 50

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor. Was 10
vim.opt.scrolloff = 8

vim.g.undotree_DiffCommand = 'FC'
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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

vim.keymap.set('n', '<Leader>q', toggle_quickfix, { desc = 'Toggle [Q]uickfix Window' })

vim.keymap.set('n', '<A-h>', '<cmd>colder<return>')
vim.keymap.set('n', '<A-j>', '<Cmd>try | cnext | catch | cfirst | catch | endtry<CR>')
vim.keymap.set('n', '<A-k>', '<Cmd>try | cprevious | catch | clast | catch | endtry<CR>')
vim.keymap.set('n', '<A-l>', '<cmd>cnewer<return>')
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Custom keymaps

-- function split_line_below_and_stay_put()
--   local current_col = vim.fn.col '.'
--   local current_line = vim.fn.getline '.'
--   local line_len = vim.fn.strlen(current_line)
--
--   -- Exit insert mode temporarily
--   vim.api.nvim_input '<Esc>'
--
--   -- Handle cursor at the very end of the line (just append a newline)
--   if current_col > line_len then
--     vim.api.nvim_command 'normal! o'
--   else
--     -- Move to the exact column, then simulate 'i<CR>'
--     vim.api.nvim_command('normal! ' .. current_col .. 'go') -- Move to byte column, robust with tabs
--     vim.api.nvim_input 'i<CR>' -- Insert newline, cursor moves to new line
--     vim.api.nvim_input '<Esc>' -- Exit insert mode from the new line
--     vim.api.nvim_command 'normal! k' -- Move up to the original line
--     vim.fn.cursor(0, current_col) -- Restore the column on the original line
--   end
--
--   -- Re-enter insert mode at the original position
--   vim.api.nvim_input 'a'
-- end
--

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

-- Optional: Normal Mode specific split_line
-- vim.api.nvim_set_keymap('n', '<Leader>sp', 'i<CR><Esc>', { noremap = true, silent = true, desc = 'Normal: Split line at cursor, cursor to new line' })
-- vim.keymap.set('i', '<C-Enter>', '<Esc>:call append(line("."), "")<CR>a', { silent = true }) --add line below
-- vim.keymap.set('i', '<C-S-Enter>', '<Esc>:call append(line(".") - 1, "")<CR>a', { silent = true })
--vim.keymap.set('i', '<C-Enter>', '<Esc>m`o<Esc>``a', { silent = true }) -- Add line below, keep cursor column
--vim.keymap.set('i', '<S-Enter>', '<Esc>m`O<Esc>``a', { silent = true }) -- Add line above, keep cursor column
-- vim.keymap.set('i', '<C-Enter>', '<Esc>o<Esc>gi', { silent = true }) -- Add line below without moving
-- vim.keymap.set('i', '<S-Enter>', '<Esc>O<Esc>gi', { silent = true }) -- Add line above without moving
-- vim.keymap.set('i', '<C-Enter>', '<C-o>o', { silent = true })
-- vim.keymap.set('i', '<S-Enter>', '<C-o>O', { silent = true })
--remap ctrl i to F13, requires a key redirect mapping in terminal emulator
vim.keymap.set('n', '<F13>', '<C-I>', { noremap = true, silent = true })
--move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
--join line from below without moving cursor
vim.keymap.set('n', 'J', 'mzJ`z')
--half page jumps keep cursor centered
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
--add relative jumps to the jumplist
vim.keymap.set('n', 'k', [[(v:count > 1 ? "m'" . v:count : "g") . 'k']], { expr = true })
vim.keymap.set('n', 'j', [[(v:count > 1 ? "m'" . v:count : "g") . 'j']], { expr = true })
--keep cursor in middle when searching
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
--quick fix and center screen
-- vim.keymap.set('n', '<C-j>', '<cmd>cnext<CR>zz')
-- vim.keymap.set('n', '<C-k>', '<cmd>cprev<CR>zz')
--
--
--Delete
--these 8 remaps prevent any delete or change operations writing to the unnamed register. Use captial D or C to cut
-- vim.keymap.set('n', 'd', '"_d', { noremap = true, desc = 'Delete to black hole register' })
-- vim.keymap.set('n', 'c', '"_c', { noremap = true, desc = 'Change to black hole register' })
-- vim.keymap.set('n', '<Del>', '"_diw', { noremap = true, desc = 'Delete word under cursor to black hole register' })
-- vim.keymap.set('n', '<BS>', '"_ciw', { noremap = true, desc = 'Change word under to black hole register' })
-- vim.keymap.set('n', '<S-Del>', 'diw', { noremap = true, desc = 'Delete word under cursor, cut to unnamed register' })
-- vim.keymap.set('n', '<S-BS>', 'ciw', { noremap = true, desc = 'Change word under cursor, cut to unnamed register' })
-- vim.keymap.set('n', 'D', 'd', { noremap = true, desc = 'delete with cut - to unnamed register' })
-- vim.keymap.set('n', 'C', 'c', { noremap = true, desc = 'change with cut - to unnamed register' })

--instead these maintain more standard behaviour with leader p to forcibly use last yank
vim.keymap.set('v', '<leader>p', '"0p', { remap = false, desc = 'Put last yank' })
-- vim.keymap.set('n', 'd', '"_d', { noremap = true, desc = 'Delete to black hole register' })
-- vim.keymap.set('n', 'c', '"_c', { noremap = true, desc = 'Change to black hole register' })
vim.keymap.set('n', '<Del>', 'diw', { noremap = true, desc = 'Delete word under cursor to black hole register' })
vim.keymap.set('n', '<BS>', 'ciw', { noremap = true, desc = 'Change word under to black hole register' })
-- vim.keymap.set('n', '<S-Del>', 'diw', { noremap = true, desc = 'Delete word under cursor, cut to unnamed register' })
-- vim.keymap.set('n', '<S-BS>', 'ciw', { noremap = true, desc = 'Change word under cursor, cut to unnamed register' })
-- vim.keymap.set('n', 'D', 'd', { noremap = true, desc = 'delete with cut - to unnamed register' })
-- vim.keymap.set('n', 'C', 'c', { noremap = true, desc = 'change with cut - to unnamed register' })

--force some operations to use black hold register
vim.keymap.set('n', 'cc', '"_cc', { noremap = true, desc = 'Change to blackhole' })
vim.keymap.set('n', 'x', '"_x', { noremap = true, desc = 'Delete char to blackhole' })
vim.keymap.set('n', 'X', 'diw', { noremap = true, desc = 'Cut word' })

--vim.keymap.set('v', 'p', '"0p', { remap = false, desc = 'Put last yank' })

vim.keymap.set('v', 'p', 'P', { noremap = true, desc = 'Put' })
vim.keymap.set('v', 'P', 'p', { noremap = true, desc = 'Put' })

vim.keymap.set('n', 's', '"_ciw<c-r>"<Esc>', { remap = false, desc = 'Replace' })
vim.keymap.set('n', 'S', '""ciw<c-r>"<Esc>', { remap = false, desc = 'Replace and Cut' })

--delete into unamed
--first attempt, d and c commands will clobber unnamed
-- vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])
-- --paste from last yanked
-- vim.keymap.set({ 'n', 'v' }, '<leader>p', '"0p')
--
-- local function smart_delete(key)
--   local l = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line number
--   local line = vim.api.nvim_buf_get_lines(0, l - 1, l, true)[1] -- Get the content of the current line
--   return (line:match '^%s*$' and '"_' or '') .. key -- If the line is empty or contains only whitespace, use the black hole register
-- end
--
-- local keys = { 'd', 'dd', 'x', 'X' } -- Define a list of keys to apply the smart delete functionality
--
-- -- Set keymaps for both normal and visual modes
-- for _, key in pairs(keys) do
--   vim.keymap.set({ 'n', 'v' }, key, function()
--     return smart_delete(key)
--   end, { noremap = true, expr = true, desc = 'Smart delete' })
-- end
--
-- --visual mode paste without changing yank register, although not consistent with other put behavior, potentially add s for substitue to preserve register, del for raw delete, leader d for delete, put will put with cut and x will also cut
-- -- vim.keymap.set('x', 'p', 'P', { remap = false, desc = 'Visual paste without clobbering yank register' })
-- -- maintain current put, put replaces and yanks, s replaces without yanking, add leader s which will replace with last yank
-- vim.keymap.set('x', '<Leader>p', '"0P', { desc = 'Paste without clobbering unnamed register' })
-- vim.keymap.set('x', '<Leader>P', '"_d"0P', { desc = 'Paste without clobbering unnamed register (before selection)' })
--
-- -- Prevent some delete operations from clobbering yank register
-- vim.keymap.set('n', 'x', '"_x', { desc = 'Delete char without affecting registers' })
-- vim.keymap.set('n', 'cc', '"_cc', { desc = 'Change line without affecting registers' })
--
-- -- quick delete or ciw
-- vim.keymap.set('n', '<BS>', 'ciw', { desc = 'Change Inner Word (Leader)' })
-- vim.keymap.set('n', '<Del>', '"_diw', { desc = 'Delete to black hole register' })
--
-- --substitute
-- vim.keymap.set('n', 'S', '"_ciw<C-r>"<Esc>', { noremap = true, nowait = true, desc = 'Replace word under cursor with default register, dot repeatable' })
-- vim.keymap.set('n', 's', '"_ciw<C-r>"<Esc>', { noremap = true, nowait = true, desc = 'Replace word under cursor with default register, dot repeatable' })
-- vim.keymap.set('x', 's', '"_dP', { noremap = true, nowait = true, desc = 'Replace word under cursor with default register, dot repeatable' })
-- vim.keymap.set('n', 'ss', '<Nop>', { noremap = true, desc = 'Disable default ss (substitute line)' })

--global put and yank
vim.keymap.set({ 'n', 'v' }, '<leader>gy', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>gp', '"+p', { desc = 'Put from clipboard' })

--source control
vim.keymap.set('n', '<leader>sca', ':Vp4Add <cr>', { desc = 'Perforce add to source control' })
vim.keymap.set('n', '<leader>sce', ':Vp4Edit <cr>', { desc = 'Perforce open for edit in source control' })
vim.keymap.set('n', '<leader>scc', ':Vp4Change <cr>', {
  desc = 'Opens the change specification in a new split. Equivalent to p4 change -o if current file is not already opened in a changelist and p4 change -o -c {cl} if already opened in a changelist. Use the write :w command to make the change, quit :q to abort.',
})
vim.keymap.set(
  'n',
  '<leader>scd',
  ':Vp4Diff <cr>',
  { desc = 'Move the current file to a different changelist. Lists all open changelists and prompts for a selection.' }
)
vim.keymap.set(
  'n',
  '<leader>scr',
  ':Vp4Reopen <cr>',
  { desc = 'Move the current file to a different changelist. Lists all open changelists and prompts for a selection.' }
)
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

-- NOTE: Smart signature info, moves to neartest parenthesis if not within a function, esc restores cursor position, so works
-- on a method name and works within nested calls
local original_cursor_pos = nil
local cursor_was_moved = false

-- Return true + open_pos if cursor is within any parens pair
local function is_cursor_inside_parens(line, col)
  local stack = {}
  local matches = {}

  for i = 1, #line do
    local char = line:sub(i, i)
    if char == '(' then
      table.insert(stack, i)
    elseif char == ')' and #stack > 0 then
      local open_pos = table.remove(stack)
      table.insert(matches, { open_pos, i })
    end
  end

  for _, pair in ipairs(matches) do
    local start_pos, end_pos = pair[1], pair[2]
    if col >= start_pos and col <= end_pos then
      return true, start_pos
    end
  end

  return false, nil
end

-- Find first '(' and return position after it
local function find_first_paren_after(line)
  local pos = line:find '%('
  if pos then
    return pos + 1 -- move just inside the paren
  end
  return nil
end

vim.keymap.set('n', '<S-KK>', function()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local col1 = col + 1 -- 1-based for Lua string funcs

  local in_parens, open_paren = is_cursor_inside_parens(line, col1)

  if in_parens then
    vim.cmd 'LspOverloadsSignature'
    return
  end

  -- Not in parens: move to first `(` + 1
  local move_to = find_first_paren_after(line)

  if move_to then
    original_cursor_pos = { row, col }
    cursor_was_moved = true

    -- Move the cursor
    vim.api.nvim_win_set_cursor(0, { row, move_to })
    vim.cmd 'LspOverloadsSignature'

    -- Esc to restore original position
    vim.keymap.set('n', '<Esc>', function()
      if cursor_was_moved and original_cursor_pos then
        vim.api.nvim_win_set_cursor(0, original_cursor_pos)
        original_cursor_pos = nil
        cursor_was_moved = false
      end
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
    end, { noremap = true, silent = true, buffer = 0 })
  else
    -- No parens found, fallback to hover
    vim.lsp.buf.hover()
  end
end, { desc = 'Smart signature help or hover' })

--share system clipboard
--vim.keymap.set('n', '<leader>y', '"+y')
--vim.keymap.set('v', '<leader>y', '"+y')
--vim.keymap.set('n', '<leader>Y', '"+Y')

vim.keymap.set('n', 'Q', '<nop>')

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
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--

local onAttach = function(event)
  -- NOTE: Remember that Lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-t>.
  map('gd', require('snacks').picker.lsp_definitions, '[G]oto [D]efinition')
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

  -- When you move your cursor, the highlights will be cleared (the second autocommand).
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.documentHighlightProvider then
    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.document_highlight,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf,
      group = highlight_augroup,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
      end,
    })

    --- Guard against servers without the signatureHelper capability
    if client.server_capabilities.signatureHelpProvider then
      -- local opts = { buffer = event.buf, noremap = true, silent = false }
      -- vim.keymap.set('n', '<C-k>', '<cmd>LspOverloadsSignature<CR>', opts)
      require('lsp-overloads').setup(client, {
        ui = {
          border = 'single',
          floating_window_above_cur_line = true,
          --max_height = 100,
        },
      })
    end

    --local bufnr = event.buf
    --if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
    -- return
    --end
    --require('lsp_signature').on_attach({
    --- ... setup options here ...
    --}, bufnr)
  end

  -- The following autocommand is used to enable inlay hints in your
  -- code, if the language server you are using supports them
  --
  -- This may be unwanted, since they displace some of your code
  if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, '[T]oggle Inlay [H]ints')
  end
end

-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --
  --  This is equivalent to:
  --    require('Comment').setup({})
  {
    'kwkarlwang/bufjump.nvim',
    config = function()
      require('bufjump').setup {
        forward_key = '<Tab>',
        backward_key = '<s-Tab>',
      }
    end,
  },
  {
    'Issafalcon/lsp-overloads.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
    end,
  },
  {
    'RobertCWebb/vim-jumpmethod',
    config = function() end,
  },
  {
    'tpope/vim-dadbod',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
    end,
  },

  {
    'kristijanhusak/vim-dadbod-ui',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
    end,
  },
  {
    'seblj/roslyn.nvim',
    config = function() end,
  },
  -- lazy.nvim
  {
    'GustavEikaas/easy-dotnet.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    config = function()
      require('easy-dotnet').setup()
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-icons' }, -- if you prefer nvim-web-devicons
  },
  {
    'ngemily/vim-vp4',
    config = function() end,
  },
  {
    'motiongorilla/p4nvim',
    config = function() end,
  },
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
    end,
  },
  {
    'stevearc/oil.nvim',
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
        '[c',
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
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
  },
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    'lewis6991/gitsigns.nvim',
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
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { 'if', mode = { 'o', 'x' } },
        textobject_field_outer = { 'af', mode = { 'o', 'x' } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  },
  { 'rose-pine/neovim', name = 'rose-pine' }, -- NOTE: Plugins can also be configured to run Lua code when they are loaded.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
        ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
        ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
        ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      }
      -- visual mode
      require('which-key').register({
        ['<leader>h'] = { 'Git [H]unk' },
      }, { mode = 'v' })
    end,
  },

  {
    'folke/snacks.nvim',
    opts = {
      picker = {},
    },
    keys = {
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader><space>',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      -- find
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Find Config File',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find Git Files',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent',
      },
      -- git
      {
        '<leader>gc',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      -- Grep
      {
        '<leader>sb',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Buffer Lines',
      },
      {
        '<leader>sB',
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = 'Grep Open Buffers',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Grep',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Visual selection or word',
        mode = { 'n', 'x' },
      },
      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>sa',
        function()
          Snacks.picker.autocmds()
        end,
        desc = 'Autocmds',
      },
      {
        '<leader>sc',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>sC',
        function()
          Snacks.picker.commands()
        end,
        desc = 'Commands',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = 'Diagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = 'Help Pages',
      },
      {
        '<leader>sH',
        function()
          Snacks.picker.highlights()
        end,
        desc = 'Highlights',
      },
      {
        '<leader>sj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Jumps',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = 'Keymaps',
      },
      {
        '<leader>sl',
        function()
          Snacks.picker.loclist()
        end,
        desc = 'Location List',
      },
      {
        '<leader>sM',
        function()
          Snacks.picker.man()
        end,
        desc = 'Man Pages',
      },
      {
        '<leader>sm',
        function()
          Snacks.picker.marks()
        end,
        desc = 'Marks',
      },
      {
        '<leader>sR',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Resume',
      },
      {
        '<leader>sq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'Quickfix List',
      },
      {
        '<leader>uC',
        function()
          Snacks.picker.colorschemes()
        end,
        desc = 'Colorschemes',
      },
      {
        '<leader>qp',
        function()
          Snacks.picker.projects()
        end,
        desc = 'Projects',
      },
      -- LSP
      -- {
      --   'gd',
      --   function()
      --     Snacks.picker.lsp_definitions()
      --   end,
      --   desc = 'Goto Definition',
      -- },
      {
        'gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = 'References',
      },
      {
        'gI',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'gy',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto T[y]pe Definition',
      },
      {
        '<leader>ss',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'LSP Symbols',
      },
      {
        '<leader>ws',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Workspace Symbols',
      },
    },
  },
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
      -- used for completion, annotations and signatures of Neovim apis
      { 'folke/neodev.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          onAttach(event)
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      require('roslyn').setup {
        on_attach = onAttach,
        capabilities = capabilities,
      }

      local lspConfig = require 'lspconfig'
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`tsserver`) will work just fine
        -- tsserver = {},
        --

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      require('mason').setup {
        registries = {
          'github:Crashdummyy/mason-registry',
          'github:mason-org/mason-registry',
        },
      }

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
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
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
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
    version = '1.51',
    dependencies = { 'saghen/blink.nvim' },
    opts = {
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'select_and_accept', 'fallback' },
      },
      -- signature = {
      --   enabled = true,
      -- },
      completion = {
        ghost_text = {
          enabled = true,
        },
        menu = {
          auto_show = false,
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
          auto_show = true,
        },
      },
    },
    -- config = function()
    --   require('blink.cmp').setup()
    -- end,
  },
  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     {
  --       'L3MON4D3/LuaSnip',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --         -- `friendly-snippets` contains a variety of premade snippets.
  --         --    See the README about individual language/framework/plugin snippets:
  --         --    https://github.com/rafamadriz/friendly-snippets
  --         -- {
  --         --   'rafamadriz/friendly-snippets',
  --         --   config = function()
  --         --     require('luasnip.loaders.from_vscode').lazy_load()
  --         --   end,
  --         -- },
  --       },
  --     },
  --     'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-path',
  --     --'hrsh7th/cmp-nvim-lsp-signature-help',
  --   },
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     local luasnip = require 'luasnip'
  --     luasnip.config.setup {}
  --
  --     cmp.setup {
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the [n]ext item
  --         -- ['<C-n>'] = cmp.mapping.select_next_item(),
  --         ['<down>'] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         -- ['<C-p>'] = cmp.mapping.select_prev_item(),
  --         ['<up>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<CR>'] = cmp.mapping.confirm { select = true },
  --
  --         -- If you prefer more traditional completion keymaps,
  --         -- you can uncomment the following lines
  --         --['<CR>'] = cmp.mapping.confirm { select = true },
  --         --['<Tab>'] = cmp.mapping.select_next_item(),
  --         --['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ['<C-l>'] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { 'i', 's' }),
  --         ['<C-h>'] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { 'i', 's' }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       },
  --       sources = {
  --         { name = 'nvim_lsp' },
  --         { name = 'luasnip' },
  --         { name = 'path' },
  --       },
  --     }
  --   end,
  -- },
  -- Using lazy.nvim
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
  -- {
  --   'gbprod/nord.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require('nord').setup {}
  --     vim.cmd.colorscheme 'nord'
  --   end,
  -- },
  -- {
  --   'aktersnurra/no-clown-fiesta.nvim',
  --   priority = 1000,
  --   config = function()
  --     local plugin = require 'no-clown-fiesta'
  --     return plugin.load(opts)
  --   end,
  --   lazy = false,
  --   opts = {
  --     theme = 'dark',
  --     styles = {
  --       type = { bold = true },
  --       lsp = { underline = false },
  --       match_paren = { underline = true },
  --     },
  --   },
  -- },

  -- {
  --   'idr4n/github-monochrome.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    opts = {
      on_highlights = function(hl, c)
        -- Make method parameters white
        hl['@parameter'] = { fg = '#ffffff' }
        hl['@variable.parameter'] = { fg = '#ffffff' }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'tokyonight-night'
      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },
  -- {
  --   'webhooked/kanso.nvim',
  --   lazy = false,
  --   priority = 1000,
  -- },

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
      require('mini.surround').setup()

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
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c_sharp', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { [']f'] = '@function.outer', [']c'] = '@class.outer', [']a'] = '@parameter.inner' },
          goto_next_end = { [']F'] = '@function.outer', [']C'] = '@class.outer', [']A'] = '@parameter.inner' },
          goto_previous_start = { ['[f'] = '@function.outer', ['[c'] = '@class.outer', ['[a'] = '@parameter.inner' },
          goto_previous_end = { ['[F'] = '@function.outer', ['[C'] = '@class.outer', ['[A'] = '@parameter.inner' },
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      -- Prefer git instead of curl in order to improve connectivity in some environments
      require('nvim-treesitter.install').prefer_git = true
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- There are additional nvim-treesitter modules that you can use to interact
      -- with nvim-treesitter. You should go explore a few and see what interests you:
      --
      --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
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

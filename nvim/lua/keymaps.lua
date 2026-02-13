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


-- vim.keymap.set('i', '<C-CR>', require('local.newline').split_line_below_and_stay_put, { desc = 'Insert: Split line below, stay on current' })
-- vim.keymap.set('i', '<S-CR>', require('local.newline').new_line_above_and_stay_put, { desc = 'Insert: New line above, stay on current' })

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

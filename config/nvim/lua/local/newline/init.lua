
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

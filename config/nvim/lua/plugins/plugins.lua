return
{
  -- INFO: Editor
  { 'tpope/vim-sleuth' }, -- Detect tabstop and shiftwidth automatically
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  -- INFO: Quality of Life
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
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
  -- INFO: mini 
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
    end,
  },
  -- INFO: standalone/own window 
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
  -- INFO: source control 
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
  { 'ngemily/vim-vp4', event = 'VeryLazy' },
  { 'motiongorilla/p4nvim', event = 'VeryLazy' },
  -- INFO: treesitter 
  {
    'nvim-treesitter/nvim-treesitter',
    event = { "BufReadPre", "BufNewFile" },
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      -- stylua: ignore
      require('nvim-treesitter').install { 'bash', 'c_sharp', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc' }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = { "BufReadPre", "BufNewFile" },
    branch = 'main',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { "BufReadPre", "BufNewFile" },
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
  -- INFO: file type specific 
  {
    'hat0uma/csvview.nvim',
    ft = 'csv',
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
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'codecompanion', 'Avante' },
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- TODO: Check icons
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-icons' }, -- if you prefer nvim-web-devicons
  },
  -- INFO: language specific
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
  { 'Issafalcon/lsp-overloads.nvim' },
  { 'RobertCWebb/vim-jumpmethod' },
  -- {
    --   'khoido2003/roslyn-filewatch.nvim',
    --   ft = 'cs',
    --   config = function()
      --     require('roslyn_filewatch').setup {
        --       -- Optional: you can tell it to ignore heavy folders to keep it fast
        --       ignore_dirs = { 'Library', 'Temp', 'Obj', 'Bin', '.git', '.idea', '.vs', '.godot', '.mono', 'node_modules' },
        --     }
        --   end,
        -- },
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
  -- INFO: Themes
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

  -- { 'armannikoyan/rusty', name = 'rusty' },
  -- { 'AlexvZyl/nordic.nvim', name = 'nordic' },
  -- {
    --   'oskarnurm/koda.nvim',
    --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
    --   priority = 1000, -- make sure to load this before all the other start plugins
    --   config = function()
      -- require("koda").setup({ transparent = true })
      --     vim.cmd 'colorscheme koda'
      --   end,
  -- },

}

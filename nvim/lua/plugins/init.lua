-- [[
-- Add plugins that doesn't need configuration here
-- ]]
return {
  'ThePrimeagen/vim-be-good',

  -- Git related plugins
  'tpope/vim-fugitive', -- Integration with git
  'tpope/vim-rhubarb',  -- Allow completion from git information such as issue etc.

  'tpope/vim-sleuth',   -- Basicly copy indentation method of the current working directory

  { 'folke/which-key.nvim',  opts = {} },

  { 'AndreM222/copilot-lualine' },
  -- the line you can see at the bottom with the indication of the mode
  {
    'nvim-lualine/lualine.nvim', -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_x = {'copilot'},
      },
    },
  },


  'nvim-lua/plenary.nvim',
  --Add indentation to blank line See `:help ibl`
  --{'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  }
}

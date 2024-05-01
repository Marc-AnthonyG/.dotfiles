-- [[ Configure gitsigns]]
-- [[ 
-- Git signs puts text in the left side of the screen to see what 
-- part of each file was changed
-- ]]
return{
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
  }

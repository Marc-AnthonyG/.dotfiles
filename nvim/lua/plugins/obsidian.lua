return {
  "Marc-AnthonyG/obsidian.nvim",
  version = "follow_new_note_in_current_folder",
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    -- Optionnal
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/repository/knowledgeBase/programming",
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,

      new_notes_location = "notes_subdir",

      prepend_note_id = true,
      prepend_note_path = false,
      use_path_only = false,
    },
    note_id_func = function(title)
      return tostring(title)
    end,
  },
}

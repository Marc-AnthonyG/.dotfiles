return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
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
		},
		new_notes_location = "notes_subdir",
		note_id_func = function(title)
			return tostring(title)
		end,
	}
}

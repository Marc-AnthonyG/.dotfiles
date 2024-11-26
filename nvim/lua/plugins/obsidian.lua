return {
	{
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
			ui = { enable = false },
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
	},
	{ 'ryleelyman/latex.nvim', opts = {} },
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			headers = {
				enabled = true,
			},
			latex = { enabled = false },
			win_options = { conceallevel = { rendered = 2 } },
		},
	}
}

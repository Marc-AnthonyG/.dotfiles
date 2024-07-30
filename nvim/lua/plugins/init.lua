return {
	{
		'ThePrimeagen/vim-be-good',
		event = "VeryLazy",
	},

	{
		'tpope/vim-fugitive',
		event = "VeryLazy",
	},

	{
		'folke/which-key.nvim',
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {}
	},

	{
		'AndreM222/copilot-lualine',
		event = "VeryLazy",
	},
	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		opts = {
			options = {
				icons_enabled = true,
				theme = 'catppuccin',
				component_separators = '|',
				section_separators = '',
			},
			sections = {
				lualine_x = { 'copilot' },
			},
		},
	},


	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {},
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},

	{
		'mg979/vim-visual-multi',
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	},

	{
		"folke/ts-comments.nvim",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {},
	},

	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		opts = {},
	},

}

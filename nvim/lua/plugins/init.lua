return {
	'ThePrimeagen/vim-be-good',

	-- Git related plugins
	'tpope/vim-fugitive', -- Integration with git

	{
		'folke/which-key.nvim',
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {}
	},

	{ 'AndreM222/copilot-lualine' },
	-- the line you can see at the bottom with the indication of the mode
	{
		'nvim-lualine/lualine.nvim', -- See `:help lualine.txt`
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


	--Add indentation to blank line See `:help ibl`
	{ 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

	--Muti cursor multi See `:help visual-multi`
	'mg979/vim-visual-multi',

	{
		"folke/ts-comments.nvim",
		event = "VeryLazy",
		opts = {},
	},

	{
		"windwp/nvim-ts-autotag",
		event = "LazyFile",
		opts = {},
	},

}

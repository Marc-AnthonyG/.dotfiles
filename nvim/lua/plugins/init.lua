return {
	{
		'tpope/vim-fugitive',
		event = 'VeryLazy',
	},
	{
		'folke/which-key.nvim',
		version = '*',
		event = 'VeryLazy',
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {},
	},
	-- { 'AndreM222/copilot-lualine' },
	{
		'nvim-lualine/lualine.nvim',
		version = '*',
		event = 'VeryLazy',
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
		'folke/snacks.nvim',
		version = '*',
		priority = 1000,
	},
	{
		'lukas-reineke/indent-blankline.nvim',
		version = '*',
		main = 'ibl',
		opts = {},
		event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
	},
	{
		'mg979/vim-visual-multi',
		version = '*',
		event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
	},
	{
		'folke/ts-comments.nvim',
		version = '*',
		event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
		opts = {},
	},
	{
		'windwp/nvim-ts-autotag',
		version = '*',
		event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
		opts = {},
	},
	{
		'MagicDuck/grug-far.nvim',
		version = '*',
		event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
		opts = { headerMaxWidth = 80 },
		cmd = 'GrugFar',
		keys = {
			{
				'<leader>sr',
				function()
					require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })
				end,
				mode = { 'n', 'v' },
				desc = 'Search and Replace',
			},
		},
	},
	{
		'tpope/vim-sleuth',
		version = '*',
		event = 'VeryLazy',
	},
	{
		'nvim-tree/nvim-web-devicons',
		opts = {
			override_by_extension = {
				['astro'] = {
					icon = '',
					color = '#81e043',
					name = 'Log',
				},
			},
		},
	},
}

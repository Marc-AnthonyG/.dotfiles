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
	{
		'lukas-reineke/indent-blankline.nvim',
		version = '*',
		main = 'ibl',
		opts = {},
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

return {
	'folke/trouble.nvim',
	version = '*',
	opts = {
		modes = {
			lsp = {
				win = { position = 'right' },
			},
		},
	},
	cmd = 'Trouble',
	keys = {
		{
			'<leader>x',
			'',
			desc = 'Trouble',
		},
		{
			'<leader>xx',
			'<cmd>Trouble diagnostics toggle<cr>',
			desc = 'Diagnostics (Trouble)',
		},
	},
}

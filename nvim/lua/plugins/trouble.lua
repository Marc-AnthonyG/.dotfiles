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
		{
			'<leader>xX',
			'<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
			desc = 'Buffer Diagnostics (Trouble)',
		},
		{
			'<leader>cs',
			'<cmd>Trouble symbols toggle focus=false<cr>',
			desc = 'Symbols (Trouble)',
		},
		{
			'<leader>cl',
			'<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
			desc = 'LSP Definitions / references / ... (Trouble)',
		},
		{
			'<leader>xL',
			'<cmd>Trouble loclist toggle<cr>',
			desc = 'Location List (Trouble)',
		},
		{
			'<leader>xQ',
			'<cmd>Trouble qflist toggle<cr>',
			desc = 'Quickfix List (Trouble)',
		},
	},
}

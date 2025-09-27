-- [[ Configure gitsigns]]
-- [[
-- Git signs puts text in the left side of the screen to see what
-- part of each file was changed
-- ]]
return {
	'lewis6991/gitsigns.nvim',
	version = '*',
	event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
	opts = {
		signs = {
			add = { text = '▎' },
			change = { text = '▎' },
			delete = { text = '' },
			topdelete = { text = '' },
			changedelete = { text = '▎' },
			untracked = { text = '▎' },
		},
		signs_staged = {
			add = { text = '▎' },
			change = { text = '▎' },
			delete = { text = '' },
			topdelete = { text = '' },
			changedelete = { text = '▎' },
		},
	},
	keys = {
		{
			'<leader>gbb',
			function()
				require('gitsigns').blame_line({ full = true })
			end,
			desc = 'Stage Hunk',
		},
		{
			'<leader>gbB',
			function()
				require('gitsigns').blame()
			end,
			desc = 'Blame',
		},
		{
			'<leader>gbd',
			function()
				require('gitsigns').diffthis()
			end,
			desc = 'Diff This',
		},
		{
			'<leader>gbD',
			function()
				require('gitsigns').diffthis('~')
			end,
			desc = 'Diff This ~',
		},
		{
			'<leader>gb',
			'',
			desc = '+[g]it [b]lame',
		},
	},
}

return {
	'dmtrKovalenko/fff.nvim',
	build = 'cargo build --release',
	opts = {
		layout = {
			width = 0.75,
			height = 0.75,
		},
		prompt = '> ',
	},
	keys = {
		{
			'<leader><leader>',
			function()
				require('fff').find_files()
			end,
			desc = 'Open file picker',
		},
		{
			'<leader>g',
			function()
				require('fff').find_in_git_root()
			end,
			desc = 'Find in [G]it root',
		},
	},
}

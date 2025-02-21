return {
	'zbirenbaum/copilot.lua',
	opts = {
		panel = {
			enabled = false,
			auto_refresh = false,
			keymap = {
				jump_prev = '[[',
				jump_next = ']]',
				accept = '<CR>',
				refresh = 'gr',
				open = '<M-CR>',
			},
			layout = {
				position = 'bottom',
				ratio = 0.4,
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,
			keymap = {
				accept = '<Tab>',
				accept_word = false,
				accept_line = false,
				next = '<M-]>',
				prev = '<M-[>',
				dismiss = '<C-]>',
			},
		},
		filetypes = {
			['*'] = true,
		},
		copilot_node_command = 'node',
		server_opts_overrides = {},
	},
	keys = {
		{
			'<leader>cd',
			'<cmd>Copilot disable<cr>',
			desc = 'Disable Copilot',
		},
		{
			'<leader>ce',
			'<cmd>Copilot enable<cr>',
			desc = 'Enable Copilot',
		},
	},
}

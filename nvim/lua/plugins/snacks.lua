---@module "snacks"

return {
	'folke/snacks.nvim',
	version = '*',
	lazy = false,
	priority = 1000,
	---@type snacks.Config
	opts = {
		notifier = { enabled = true },
		input = { enabled = true },
		words = { enabled = true },
		picker = { enabled = true },
	},
	keys = {
		-- Top Pickers & Explorer
		{
			'<leader>,',
			function()
				Snacks.picker.buffers()
			end,
			desc = 'Buffers',
		},
		{
			'<leader>sg',
			function()
				Snacks.picker.grep()
			end,
			desc = 'Grep',
		},
		{
			'<leader>:',
			function()
				Snacks.picker.command_history()
			end,
			desc = 'Command History',
		},
		{
			'<leader>n',
			function()
				Snacks.picker.notifications()
			end,
			desc = 'Notification History',
		},
		-- Grep
		{
			'<leader>s/',
			function()
				Snacks.picker.search_history()
			end,
			desc = 'Search History',
		},
		{
			'<leader>pa',
			function()
				Snacks.picker.autocmds()
			end,
			desc = 'Autocmds',
		},
		{
			'<leader>pH',
			function()
				Snacks.picker.command_history()
			end,
			desc = 'Command History',
		},
		{
			'<leader>pC',
			function()
				Snacks.picker.commands()
			end,
			desc = 'Commands',
		},
		{
			'<leader>ph',
			function()
				Snacks.picker.help()
			end,
			desc = 'Help Pages',
		},
		{
			'<leader>pk',
			function()
				Snacks.picker.keymaps()
			end,
			desc = 'Keymaps',
		},
		{
			'<leader>pq',
			function()
				Snacks.picker.qflist()
			end,
			desc = 'Quickfix List',
		},
		{
			'<leader>pR',
			function()
				Snacks.picker.resume()
			end,
			desc = 'Resume',
		},
		{
			'<leader>pu',
			function()
				Snacks.picker.undo()
			end,
			desc = 'Undo History',
		},
		{
			'<leader>pC',
			function()
				Snacks.picker.colorschemes()
			end,
			desc = 'Colorschemes',
		},
		-- LSP
		{
			'gd',
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = 'Goto Definition',
		},
		{
			'<leader>r',
			vim.lsp.buf.rename,
			desc = 'Rename',
		},
		{
			'<leader>ca',
			vim.lsp.buf.code_action,
			desc = 'Code Action',
			mode = { 'n', 'v' },
		},
		{
			'gD',
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = 'Goto Declaration',
		},
		{
			'gr',
			function()
				Snacks.picker.lsp_references()
			end,
			nowait = true,
			desc = 'References',
		},
		{
			'gI',
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = 'Goto Implementation',
		},
		{
			'gy',
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = 'Goto T[y]pe Definition',
		},
		{
			'<leader>fr',
			function()
				Snacks.rename.rename_file()
			end,
			desc = 'Rename File',
		},
		{
			'<leader>gB',
			function()
				Snacks.gitbrowse()
			end,
			desc = 'Git Browse',
			mode = { 'n', 'v' },
		},
	},
}

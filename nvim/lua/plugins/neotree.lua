local Snacks = require('plugins.snacks')
-- file explorer
return {
	'nvim-neo-tree/neo-tree.nvim',
	version = '*',
	cmd = 'Neotree',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'MunifTanjim/nui.nvim',
	},
	keys = {
		{
			'<leader>e',
			function()
				require('neo-tree.command').execute({ toggle = true, dir = vim.uv.cwd() })
			end,
			desc = '[e]xplorer NeoTree (cwd)',
		},
		{
			'<leader>cE',
			':Neotree toggle reveal_force_cwd<CR>',
			desc = '[c]urrent [E]xplorer',
		},
		{
			'<leader>ge',
			function()
				require('neo-tree.command').execute({ source = 'git_status', toggle = true })
			end,
			desc = 'Git Explorer',
		},
		{
			'<leader>be',
			function()
				require('neo-tree.command').execute({ source = 'buffers', toggle = true })
			end,
			desc = '[b]uffer [e]xplorer',
		},
		{ '<leader>sc', ':Neotre filesystem reveal<CR>', desc = '[sc]ope on current file' },
	},
	deactivate = function()
		vim.cmd([[Neotree close]])
	end,
	init = function()
		vim.api.nvim_create_autocmd('BufEnter', {
			group = vim.api.nvim_create_augroup('Neotree_start_directory', { clear = true }),
			desc = 'Start Neo-tree with directory',
			once = true,
			callback = function()
				if package.loaded['neo-tree'] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == 'directory' then
						require('neo-tree')
					end
				end
			end,
		})
	end,
	opts = {
		enable_git_status = false,
		close_if_last_window = true,
		open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
		filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = false },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
				hide_hidden = false,
			},
		},
		window = {
			mappings = {
				['l'] = 'open',
				['h'] = 'close_node',
				['<space>'] = 'none',
				['Y'] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg('+', path, 'c')
					end,
					desc = 'Copy Path to Clipboard',
				},
				['O'] = {
					function(state)
						require('lazy.util').open(state.tree:get_node().path, { system = true })
					end,
					desc = 'Open with System Application',
				},
				['P'] = { 'toggle_preview', config = { use_float = false } },
				['d'] = 'add_directory',
				['D'] = 'delete',
				['%'] = {
					'add',
					config = {
						show_path = 'none',
					},
				},
			},
		},
		default_component_configs = {
			indent = {
				with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
				expander_collapsed = '',
				expander_expanded = '',
				expander_highlight = 'NeoTreeExpander',
			},
			git_status = {
				symbols = {
					unstaged = '󰄱',
					staged = '󰱒',
				},
			},
		},
	},
	config = function(_, opts)
		local function on_move(data)
			Snacks.rename.on_rename_file(data.source, data.destination)
		end

		local events = require('neo-tree.events')
		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})
		require('neo-tree').setup(opts)
	end,
}

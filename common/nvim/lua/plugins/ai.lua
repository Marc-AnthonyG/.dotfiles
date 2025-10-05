return {
	{
		'zbirenbaum/copilot.lua',
		event = { 'InsertEnter' },
		cmd = 'Copilot',
		opts = {
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = '[[',
					jump_next = ']]',
					accept = '<CR>',
					refresh = 'gr',
					open = '<M-CR>',
				},
				layout = {
					position = 'bottom', -- | top | left | right | bottom |
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				debounce = 75,
				trigger_on_accept = true,
				keymap = {
					accept = '<tab>',
					accept_word = false,
					accept_line = false,
					next = '<M-]>',
					prev = '<M-[>',
					dismiss = '<C-]>',
				},
			},
			root_dir = function()
				return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
			end,
			should_attach = function(_, _)
				if not vim.bo.buflisted then
					Util.log.debug("not attaching, buffer is not 'buflisted'")
					return false
				end

				if vim.bo.buftype ~= '' then
					Util.log.debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
					return false
				end

				Util.log.debug('Copilot attaching to current buffer.')
				return true
			end,
			server = {
				type = 'nodejs', -- "nodejs" | "binary"
				custom_server_filepath = nil,
			},
			server_opts_overrides = {},
		},
	},
	{
		'folke/sidekick.nvim',
		dependencies = {
			'zbirenbaum/copilot.lua',
		},
		opts = function()
			-- Accept inline suggestions or next edits
			Util.cmp.actions.ai_nes = function()
				local Nes = require('sidekick.nes')
				if Nes.have() and (Nes.jump() or Nes.apply()) then
					return true
				end
			end
		end,
		keys = {
			-- nes is also useful in normal mode
			{ '<tab>', Util.cmp.map({ 'ai_nes' }, '<tab>'), mode = { 'n' }, expr = true },
			{ '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
			{
				'<leader>aa',
				function()
					require('sidekick.cli').toggle()
				end,
				desc = 'Sidekick Toggle CLI',
			},
			{
				'<leader>as',
				function()
					require('sidekick.cli').select()
				end,
				mode = { 'n' },
				desc = 'Sidekick Select CLI',
			},
			{
				'<leader>as',
				function()
					require('sidekick.cli').send()
				end,
				mode = { 'v' },
				desc = 'Sidekick Send Visual Selection',
			},
			{
				'<leader>ap',
				function()
					require('sidekick.cli').prompt()
				end,
				desc = 'Sidekick Select Prompt',
				mode = { 'n', 'v' },
			},
			{
				'<c-.>',
				function()
					require('sidekick.cli').focus()
				end,
				mode = { 'n', 'x', 'i', 't' },
				desc = 'Sidekick Switch Focus',
			},
		},
	},
}

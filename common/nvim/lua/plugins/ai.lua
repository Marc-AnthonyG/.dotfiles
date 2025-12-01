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
				hide_during_completion = true,
				debounce = 75,
				trigger_on_accept = true,
			},
			root_dir = function()
				return vim.fs.dirname(vim.fs.find('.git', { upward = true })[1])
			end,
			should_attach = function(_, _)
				if not vim.bo.buflisted then
					return false
				end

				if vim.bo.buftype ~= '' then
					return false
				end

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
		'zbirenbaum/copilot.lua',
		opts = function()
			Util.cmp.actions.ai_accept = function()
				if require('copilot.suggestion').is_visible() then
					require('copilot.suggestion').accept()
					return true
				end
			end
		end,
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
				local copilot_suggestion = require('copilot.suggestion')
				if Nes.have() and (Nes.jump() or Nes.apply()) then
					return true
				elseif copilot_suggestion and copilot_suggestion.is_visible() then
					copilot_suggestion.accept()
					return true
				end
			end
		end,
		keys = {
			-- nes is also useful in normal mode
			{
				'<tab>',
				function()
					-- if there is a next edit, jump to it, otherwise apply it if any
					if not require('sidekick').nes_jump_or_apply() then
						return '<Tab>' -- fallback to normal tab
					end
				end,
				expr = true,
				desc = 'Goto/Apply Next Edit Suggestion',
			},
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
	{
		'saghen/blink.cmp',
		dependencies = { 'fang2hou/blink-copilot' },
		opts = {
			sources = {
				default = { 'copilot' },
				providers = {
					copilot = {
						name = 'copilot',
						module = 'blink-copilot',
						score_offset = 100,
						async = true,
					},
				},
			},
		},
	},
}

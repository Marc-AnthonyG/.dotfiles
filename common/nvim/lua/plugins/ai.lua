return {
	{
		'folke/sidekick.nvim',
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

-- [[ Configure gitsigns]]
-- [[
-- Git signs puts text in the left side of the screen to see what
-- part of each file was changed
-- ]]
return {
	'lewis6991/gitsigns.nvim',
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
		on_attach = function(buffer)
			local gs = require('gitsigns')

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
			end

			map('n', ']h', function()
				if vim.wo.diff then
					vim.cmd.normal({ ']c', bang = true })
				else
					gs.nav_hunk('next')
				end
			end, 'Next Hunk')
			map('n', '[h', function()
				if vim.wo.diff then
					vim.cmd.normal({ '[c', bang = true })
				else
					gs.nav_hunk('prev')
				end
			end, 'Prev Hunk')
			map('n', ']H', function()
				gs.nav_hunk('last')
			end, 'Last Hunk')
			map('n', '[H', function()
				gs.nav_hunk('first')
			end, 'First Hunk')
			map({ 'n', 'v' }, '<leader>gbs', ':Gitsigns stage_hunk<CR>', 'Stage Hunk')
			map({ 'n', 'v' }, '<leader>gbr', ':Gitsigns reset_hunk<CR>', 'Reset Hunk')
			map('n', '<leader>gbS', gs.stage_buffer, 'Stage Buffer')
			map('n', '<leader>gbu', gs.stage_hunk, 'Undo Stage Hunk')
			map('n', '<leader>gbR', gs.reset_buffer, 'Reset Buffer')
			map('n', '<leader>gbp', gs.preview_hunk_inline, 'Preview Hunk Inline')
			map('n', '<leader>gbb', function()
				gs.blame_line({ full = true })
			end, 'Blame Line')
			map('n', '<leader>gbB', function()
				gs.blame()
			end, 'Blame Buffer')
			map('n', '<leader>gbd', gs.diffthis, 'Diff This')
			map('n', '<leader>gbD', function()
				gs.diffthis('~')
			end, 'Diff This ~')
			vim.keymap.set('n', '<leader>gb', '', { desc = '+[g]it [b]lame' })
		end,
	},
}

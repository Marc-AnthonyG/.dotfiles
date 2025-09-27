return {
	'supermaven-inc/supermaven-nvim',
	config = function()
		require('supermaven-nvim').setup({})
	end,

	-- 'zbirenbaum/copilot.lua',
	-- requires = {
	-- 	'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
	-- },
	-- cmd = 'Copilot',
	-- event = 'InsertEnter',
	-- opt = {
	-- 	nes = {
	-- 		enabled = true,
	-- 		keymap = {
	-- 			accept_and_goto = '<leader>o',
	-- 			accept = false,
	-- 			dismiss = '<Esc>',
	-- 		},
	-- 	},
	-- },
}

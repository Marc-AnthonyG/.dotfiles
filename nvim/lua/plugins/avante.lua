return {
	'yetone/avante.nvim',
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = 'make',
	event = 'VeryLazy',
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	opts = {
		-- add any opts here
		-- this file can contain specific instructions for your project
		instructions_file = 'avante.md',
		-- for example
		provider = 'claude',
		providers = {
			claude = {
				endpoint = 'https://api.anthropic.com',
				model = 'claude-sonnet-4-20250514',
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 20480,
				},
			},
		},
	},
	dependencies = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		--- The below dependencies are optional,
		'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
		'folke/snacks.nvim', -- for input provider snacks
	},
}

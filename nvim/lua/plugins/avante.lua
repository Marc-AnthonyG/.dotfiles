return {
	'yetone/avante.nvim',
	event = 'VeryLazy',
	version = '*',
	build = 'make',
	opts = {
		---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
		provider = 'claude',
		---@alias Mode "agentic" | "legacy"
		mode = 'agentic',
		auto_suggestions_provider = 'claude',
		providers = {
			claude = {
				endpoint = 'https://api.anthropic.com',
				model = 'claude-3-5-sonnet-20241022',
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 4096,
				},
			},
		},
		dual_boost = {
			enabled = false,
			first_provider = 'openai',
			second_provider = 'claude',
			prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
			timeout = 60000, -- Timeout in milliseconds
		},
		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true,
			enable_token_counting = true,
			auto_approve_tool_permissions = false,
		},
		mappings = {
			--- @class AvanteConflictMappings
			diff = {
				ours = 'co',
				theirs = 'ct',
				all_theirs = 'ca',
				both = 'cb',
				cursor = 'cc',
				next = ']x',
				prev = '[x',
			},
			suggestion = {
				accept = '<M-l>',
				next = '<M-]>',
				prev = '<M-[>',
				dismiss = '<C-]>',
			},
			jump = {
				next = ']]',
				prev = '[[',
			},
			submit = {
				normal = '<CR>',
				insert = '<C-s>',
			},
			cancel = {
				normal = { '<C-c>', '<Esc>', 'q' },
				insert = { '<C-c>' },
			},
			sidebar = {
				apply_all = 'A',
				apply_cursor = 'a',
				retry_user_request = 'r',
				edit_user_request = 'e',
				switch_windows = '<Tab>',
				reverse_switch_windows = '<S-Tab>',
				remove_file = 'd',
				add_file = '@',
				close = { '<Esc>', 'q' },
				close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
			},
		},
		hints = { enabled = true },
		windows = {
			---@type "right" | "left" | "top" | "bottom"
			position = 'right', -- the position of the sidebar
			wrap = true, -- similar to vim.o.wrap
			width = 30, -- default % based on available width
			sidebar_header = {
				enabled = true, -- true, false to enable/disable the header
				align = 'center', -- left, center, right for title
				rounded = true,
			},
			input = {
				prefix = '> ',
				height = 8, -- Height of the input window in vertical layout
			},
			edit = {
				border = 'rounded',
				start_insert = true, -- Start insert mode when opening the edit window
			},
			ask = {
				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = true, -- Start insert mode when opening the ask window
				border = 'rounded',
				---@type "ours" | "theirs"
				focus_on_apply = 'ours', -- which diff to focus after applying
			},
		},
		highlights = {
			---@type AvanteConflictHighlights
			diff = {
				current = 'DiffText',
				incoming = 'DiffAdd',
			},
		},
		--- @class AvanteConflictUserConfig
		diff = {
			autojump = true,
			---@type string | fun(): any
			list_opener = 'copen',
			--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
			--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
			--- Disable by setting to -1.
			override_timeoutlen = 500,
		},
		suggestion = {
			debounce = 600,
			throttle = 600,
		},
	},
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
		'echasnovski/mini.pick',
		'nvim-telescope/telescope.nvim',
		'hrsh7th/nvim-cmp',
		'ibhagwan/fzf-lua',
		'stevearc/dressing.nvim',
		'folke/snacks.nvim',
		'nvim-tree/nvim-web-devicons',
		{
			'MeanderingProgrammer/render-markdown.nvim',
			opts = {
				file_types = { 'markdown', 'Avante' },
			},
			ft = { 'markdown', 'Avante' },
		},
	},
}

-- [[  Theme inspired by Atom
return {
	'catppuccin/nvim',
	priority = 1000,
	opts = {
		flavour = 'mocha',
		transparent_background = true,
		show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
		dim_inactive = {
			enabled = true, -- dims the background color of inactive window
			shade = 'dark',
			percentage = 0.15, -- percentage of the shade to apply to the inactive window
		},
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			comments = { 'italic' }, -- Change the style of comments
			conditionals = { 'italic' },
			loops = {},
			functions = {},
			keywords = { 'bold' },
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {},
		custom_highlights = function(colors)
			return {
				Comment = { fg = '#89AEB1' },
				LineNr = { fg = colors.overlay0 },
			}
		end,
		integrations = {
			cmp = true,
			gitsigns = true,
			treesitter = true,
			telescope = true,
			mason = true,
			harpoon = true,
			mini = {
				enabled = true,
				indentscope_color = '',
			},
		},
	},
	config = function()
		require('catppuccin').setup(opts)
		vim.cmd.colorscheme('catppuccin')
		vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
	end,
}

-- [[  Theme inspired by Atom
return {
	'catppuccin/nvim',
	priority = 1000,
	opts = {
		flavour = 'mocha',
		transparent_background = true,
		dim_inactive = {
			enabled = true, -- dims the background color of inactive window
		},
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			keywords = { 'bold' },
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
			snacks = true,
			mason = true,
			harpoon = true,
			mini = {
				enabled = true,
				indentscope_color = '',
			},
		},
	},
	config = function(opts)
		require('catppuccin').setup(opts)
		vim.cmd.colorscheme('catppuccin')
		vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
	end,
}

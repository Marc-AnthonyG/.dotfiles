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

		--- Modifies the background of an existing highlight group to be transparent ('none').
		--- Preserves its foreground, style, and links.
		--- @param group_name string The name of the highlight group (e.g., "Normal")
		local function create_hl_transparent(group_name)
			local hl_def = vim.api.nvim_get_hl(0, { name = group_name })
			local updated_opts = {
				bg = 'none',
				ctermbg = 'none',
			}

			--- Override hl def with updated options
			return vim.tbl_extend('force', hl_def, updated_opts)
		end

		vim.api.nvim_set_hl(0, 'Normal', create_hl_transparent('Normal'))
		vim.api.nvim_set_hl(0, 'NormalFloat', create_hl_transparent('NormalFloat'))
	end,
}

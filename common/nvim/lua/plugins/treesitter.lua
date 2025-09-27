return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		vim.defer_fn(function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = {
					'go',
					'lua',
					'python',
					'rust',
					'tsx',
					'javascript',
					'typescript',
					'vimdoc',
					'vim',
					'bash',
					'markdown',
					'markdown_inline',
					'regex',
				},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = '<c-space>',
						node_incremental = '<c-space>',
						scope_incremental = '<c-s>',
						node_decremental = '<M-space>',
					},
				},
				sync_install = false,
				ignore_install = {},
				modules = {},
			})
		end, 0)
	end,
}

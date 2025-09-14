return {
	'mason-org/mason-lspconfig.nvim',
	version = '*',
	opts = {
		ensure_installed = { 'lua_ls', 'rust_analyzer' },
	},
	dependencies = {
		{ 'mason-org/mason.nvim', opts = {}, version = '*' },
		{ 'neovim/nvim-lspconfig', version = '*' },
	},
	init = function(_, opts)
		require('mason').setup(opts)
		require('mason-registry'):on('package:install:success', function()
			Util.log.info('Mason package successfully installed! Reloading buffer...')
			vim.defer_fn(function()
				require('lazy.core.handler.event').trigger({
					event = 'FileType',
					buf = vim.api.nvim_get_current_buf(),
				})
			end, 100)
		end)
	end,
}

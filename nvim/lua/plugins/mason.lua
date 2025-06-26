return {
	'williamboman/mason.nvim',
	version = '*',
	cmd = 'Mason',
	build = ':MasonUpdate',
	opts_extend = { 'ensure_installed' },
	opts = {
		ensure_installed = {
			'stylua',
			'shfmt',
			'clang-format',
			'clangd',
			'cmake-language-server',
			'eslint-lsp',
			'json-lsp',
			'lua-language-server',
			'markdownlint',
			'mypy',
			'ruff',
			'rust-analyzer',
			'tailwindcss-language-server',
			'terraform-ls',
			'typescript-language-server',
			'yamllint',
			'codelldb',
		},
	},
	config = function(_, opts)
		require('mason').setup(opts)
		local mr = require('mason-registry')
		mr:on('package:install:success', function()
			vim.defer_fn(function()
				require('lazy.core.handler.event').trigger({
					event = 'FileType',
					buf = vim.api.nvim_get_current_buf(),
				})
			end, 100)
		end)

		mr.refresh(function()
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end)
	end,
}

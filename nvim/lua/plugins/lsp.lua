-- [[ Configure LSP ]]
return {
	'neovim/nvim-lspconfig',
	event = "VeryLazy",
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		{ 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP
		'folke/neodev.nvim',          -- completion for nvim api
	},
	config = function()
		require('neodev').setup()

		local on_attach = function(_, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

			nmap('<leader>r', vim.lsp.buf.rename, '[R]ename')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
			nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
			nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
			nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
				'[W]orkspace [S]ymbols')

			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
			nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end

		require('mason').setup()
		require('mason-lspconfig').setup()

		local servers = {
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'

		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers),
		}

		mason_lspconfig.setup_handlers {
			function(server_name)
				require('lspconfig')[server_name].setup {
					capabilities = capabilities,
					on_attach = on_attach, -- is calling on attach define in lsp config
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				}
			end,
		}
	end
}

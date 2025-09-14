return {
	-- lspconfig
	'neovim/nvim-lspconfig',
	event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
	dependencies = {
		{ 'mason-org/mason.nvim', version = '1.11.0' },
		{
			'mason-org/mason-lspconfig.nvim',
			version = '1.x.x',
			opts = {},
			config = function(_, opts)
				require('mason').setup(opts)
				local mr = require('mason-registry')
				--- Trigger buffer reloading after installing a package (allow to load directly)
				mr:on('package:install:success', function()
					vim.defer_fn(function()
						require('lazy.core.handler.event').trigger({
							event = 'FileType',
							buf = vim.api.nvim_get_current_buf(),
						})
					end, 100)
				end)
			end,
		},
	},
	opts = function()
		local ret = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = 'if_many',
					prefix = 'icons',
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = ' ',
						[vim.diagnostic.severity.WARN] = ' ',
						[vim.diagnostic.severity.HINT] = '',
						[vim.diagnostic.severity.INFO] = '',
					},
				},
			},
			inlay_hints = {
				enabled = true,
			},
			codelens = {
				enabled = true,
			},
			document_highlight = {
				enabled = true,
			},
			capabilities = {
				workspace = {
					fileOperations = {
						didRename = true,
						willRename = true,
					},
				},
			},
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = 'Replace',
							},
							doc = {
								privateName = { '^_' },
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = 'Disable',
								semicolon = 'Disable',
								arrayIndex = 'Disable',
							},
						},
					},
				},
			},
			setup = {
				eslint = function()
					Util.format.register({
						name = 'eslint: lsp',
						primary = false,
						priority = Util.format.LSP_PRIORITY + 1,
						format = function()
							vim.cmd.EslintFixAll()
						end,
						sources = function(buf)
							local clients = Util.lsp.get_clients({ bufnr = buf, name = 'eslint' })
							return vim.tbl_map(
								function(client)
									return client.name
								end,
								vim.tbl_filter(function(client)
									return client.supports_method('textDocument/formatting')
								end, clients)
							)
						end,
					})
				end,
			},
		}
		return ret
	end,
	config = function(_, opts)
		-- setup autoformat
		Util.format.register(Util.lsp.formatter())

		-- inlay hints
		if opts.inlay_hints.enabled then
			Util.lsp.on_supports_method('textDocument/inlayHint', function(_, buffer)
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end)
		end

		-- code lens
		if opts.codelens.enabled then
			Util.lsp.on_supports_method('textDocument/codeLens', function(_, buffer)
				vim.lsp.codelens.refresh()
				vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
					buffer = buffer,
					callback = vim.lsp.codelens.refresh,
				})
			end)
		end

		-- Setup diagnostics virtual text and icons
		if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
			opts.diagnostics.virtual_text.prefix = function(diagnostic)
				for d, icon in pairs({
					Error = ' ',
					Warn = ' ',
					Hint = ' ',
					Info = ' ',
				}) do
					if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
						return icon
					end
				end
			end
		end
		vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

		local servers = opts.servers
		local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
		local capabilities = vim.tbl_deep_extend(
			'force',
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp and cmp_nvim_lsp.default_capabilities() or {},
			opts.capabilities or {}
		)

		local function setup(server)
			local server_opts = vim.tbl_deep_extend('force', {
				capabilities = vim.deepcopy(capabilities),
			}, servers[server] or {})
			if server_opts.enabled == false then
				return
			end

			-- Setup with server specific setup function
			if opts.setup[server] then
				if opts.setup[server](server, server_opts) then
					return
				end
			-- Or setup with a wildcard setup function
			elseif opts.setup['*'] then
				if opts.setup['*'](server, server_opts) then
					return
				end
			end

			-- Fallback to lspconfig setup (also if setup failed)
			require('lspconfig')[server].setup(server_opts)
		end

		-- Setup handlers for lsp servers
		require('mason-lspconfig').setup({ handlers = { setup } })
		-- vim.api.nvim_create_autocmd('LspAttach', {
		-- 	group = vim.api.nvim_create_augroup('custom_lsp_attach', { clear = true }),
		-- 	callback = function(args)
		-- 		Util.log.debug('LspAttach', args)
		-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
		-- 		if not client then
		-- 			return
		-- 		end
		-- 		Util.log.debug('LspAttach client', client)
		-- 		setup(client.name)
		-- 	end,
		-- })
	end,
}

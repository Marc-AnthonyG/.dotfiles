return {
	-- lspconfig
	'neovim/nvim-lspconfig',
	version = '*',
	event = { 'BufReadPost', 'BufNewFile', 'BufWritePre' },
	dependencies = {
		'mason.nvim',
		{ 'williamboman/mason-lspconfig.nvim', config = function() end },
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
				enabled = false,
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
			-- LSP Server Settings
			-- add servers and special configuration here
			servers = {
				lua_ls = {
					-- ---@type LazyKeysSpec[]
					-- keys = {},
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
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		}
		return ret
	end,
	config = function(_, opts)
		-- setup autoformat
		Util.format.register(Util.lsp.formatter())

		-- setup keymaps
		Util.lsp.on_attach(function(client, buffer)
			require('plugins.lsp.keymaps').on_attach(client, buffer)
		end)

		Util.lsp.setup()
		Util.lsp.on_dynamic_capability(require('plugins.lsp.keymaps').on_attach)

		Util.lsp.words.setup(opts.document_highlight)

		-- inlay hints
		if opts.inlay_hints.enabled then
			Util.lsp.on_supports_method('textDocument/inlayHint', function(_, buffer)
				vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
			end)
		end

		-- code lens
		if opts.codelens.enabled and vim.lsp.codelens then
			Util.lsp.on_supports_method('textDocument/codeLens', function(_, buffer)
				vim.lsp.codelens.refresh()
				vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
					buffer = buffer,
					callback = vim.lsp.codelens.refresh,
				})
			end)
		end

		if type(opts.diagnostics.virtual_text) == 'table' and opts.diagnostics.virtual_text.prefix == 'icons' then
			opts.diagnostics.virtual_text.prefix = vim.fn.has('nvim-0.10.0') == 0 and '●'
				or function(diagnostic)
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

			if opts.setup[server] then
				if opts.setup[server](server, server_opts) then
					return
				end
			elseif opts.setup['*'] then
				if opts.setup['*'](server, server_opts) then
					return
				end
			end
			require('lspconfig')[server].setup(server_opts)
		end

		-- get all the servers that are available through mason-lspconfig
		local have_mason, mlsp = pcall(require, 'mason-lspconfig')

		local ensure_installed = {} ---@type string[]
		for server, server_opts in pairs(servers) do
			if server_opts then
				server_opts = server_opts == true and {} or server_opts
				if server_opts.enabled ~= false then
					ensure_installed[#ensure_installed + 1] = server
				end
			end
		end

		if have_mason then
			mlsp.setup({
				ensure_installed = vim.tbl_deep_extend(
					'force',
					ensure_installed,
					Util.opts('mason-lspconfig.nvim').ensure_installed or {}
				),
				handlers = { setup },
			})
		end
	end,
}

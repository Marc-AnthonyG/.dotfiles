---@type VimLspConfig
return {
	on_init = function(_, _)
		Util.format.register({
			name = 'eslint: lsp',
			primary = false,
			priority = Util.format.LSP_PRIORITY + 1,
			format = function()
				vim.cmd.LspEslintFixAll()
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
}

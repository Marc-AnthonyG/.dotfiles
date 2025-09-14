Util.format.register(Util.lsp.formatter())

-- inlay hints
Util.lsp.on_supports_method('textDocument/inlayHint', function(_, buffer)
	vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
end)

-- code lens
-- Util.lsp.on_supports_method('textDocument/codeLens', function(_, buffer)
-- 	vim.lsp.codelens.refresh()
-- 	vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
-- 		buffer = buffer,
-- 		callback = vim.lsp.codelens.refresh,
-- 	})
-- end)

-- Setup diagnostics virtual text and icons
local prefix = function(diagnostic)
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
vim.diagnostic.config(vim.deepcopy({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = 'if_many',
		prefix = prefix,
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
}))

-- Default lsp config
vim.lsp.config('*', {
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
	on_attach = Util.lsp.on_attach_supports_method,
})

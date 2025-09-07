vim.api.nvim_create_autocmd('LspProgress', {
	---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
	callback = function(ev)
		local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
		vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
			id = 'lsp_progress',
			title = 'LSP Progress',
			opts = function(notif)
				notif.icon = ev.data.params.value.kind == 'end' and ' '
					or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
			end,
		})
	end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
	pattern = { 'json', 'jsonc', 'json5' },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})

Util.format.create_auto_cmd()

vim.api.nvim_create_user_command('Format', function()
	Util.format.format({ force = true })
end, { desc = 'Format current buffer' })

-- Format info
vim.api.nvim_create_user_command('FormatInfo', function()
	Util.format.info()
end, { desc = 'Show info about the formatters for the current buffer' })

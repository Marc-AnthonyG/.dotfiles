-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<leader>f', '<cmd>Format<CR>', { desc = '[f]ormat' })

-- Go back a buffer
vim.keymap.set('n', 'gb', '<cmd>BufferLineCyclePrev<CR>', { desc = '[g]o [b]ack a buffer' })

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Center the view after scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Move Lines
vim.keymap.set({ 'v', 'n' }, '<leader>c', '', { desc = 'Code' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

vim.keymap.set('n', '<leader>xl', function()
	vim.diagnostic.open_float({ scope = 'line' })
end, { desc = 'Show [l]ine Diagnostics' })

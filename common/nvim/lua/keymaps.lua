-- OS detection
local is_arch = vim.fn.filereadable('/etc/arch-release') == 1
Util.log.debug('OS detected as ' .. (is_arch and 'Arch' or 'Other'), { title = 'My Config' })
local ctrl = is_arch and '<M-' or '<C-'
Util.log.debug('Super key detected as ' .. ctrl, { title = 'My Config' })

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<leader>f', '<cmd>Format<CR>', { desc = '[f]ormat' })

-- Go back a buffer
vim.keymap.set('n', 'gb', '<cmd>BufferLineCyclePrev<CR>', { desc = '[g]o [b]ack a buffer' })

-- Keymaps for better default experience
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Center the view after scrolling
vim.keymap.set('n', ctrl .. 'd>', ctrl .. 'd>zz')
vim.keymap.set('n', ctrl .. 'u>', ctrl .. 'u>zz')

-- Arch-specific Super key mappings for window management
if is_arch then
	Util.log.debug('OS detected as Arch', { title = 'My Config' })
	vim.keymap.set('n', ctrl .. 'w>', '<C-w>', { desc = '+ window' })

	-- Window navigation (Super+hjkl)
	vim.keymap.set('n', ctrl .. 'w>h', '<C-w>h', { desc = 'Go to the left window' })
	vim.keymap.set('n', ctrl .. 'w>H', '<C-w>H', { desc = 'Move window to far left' })
	vim.keymap.set('n', ctrl .. 'w>j', '<C-w>j', { desc = 'Go to the bottom window' })
	vim.keymap.set('n', ctrl .. 'w>J', '<C-w>J', { desc = 'Move window to far bottom' })
	vim.keymap.set('n', ctrl .. 'w>k', '<C-w>k', { desc = 'Go to the top window' })
	vim.keymap.set('n', ctrl .. 'w>K', '<C-w>K', { desc = 'Move window to far top' })
	vim.keymap.set('n', ctrl .. 'w>l', '<C-w>l', { desc = 'Go to the right window' })
	vim.keymap.set('n', ctrl .. 'w>L', '<C-w>L', { desc = 'Move window to far right' })

	-- Window splitting (Super+v/s)
	vim.keymap.set('n', ctrl .. 'w>v', '<C-w>v', { desc = 'Split window vertically' })
	vim.keymap.set('n', ctrl .. 'w>s', '<C-w>s', { desc = 'Split window horizontally' })
	vim.keymap.set('n', ctrl .. 'w>T', '<C-w>T', { desc = 'Break out into a new tab' })

	-- Switch windows (Super+w)
	vim.keymap.set('n', ctrl .. 'w>w', '<C-w>w', { desc = 'Switch to next window' })
	vim.keymap.set('n', ctrl .. 'w>x', '<C-w>x', { desc = 'Swap current with next window' })

	-- Window closing (Super+q)
	vim.keymap.set('n', ctrl .. 'w>q', '<C-w>q', { desc = 'Close window' })
	vim.keymap.set('n', ctrl .. 'w>o', '<C-w>o', { desc = 'Close all other windows' })

	-- Window resizing (Super+arrow keys)
	vim.keymap.set('n', ctrl .. 'w>Left', '<C-w><', { desc = 'Decrease window width' })
	vim.keymap.set('n', ctrl .. 'w>Right', '<C-w>>', { desc = 'Increase window width' })
	vim.keymap.set('n', ctrl .. 'w>Up', '<C-w>+', { desc = 'Increase window height' })
	vim.keymap.set('n', ctrl .. 'w>Down', '<C-w>-', { desc = 'Decrease window height' })
	vim.keymap.set('n', ctrl .. 'w>=', '<C-w>=', { desc = 'Make window equal height or width' })
	vim.keymap.set('n', ctrl .. 'w>_', '<C-w>_', { desc = 'Max out height' })
	vim.keymap.set('n', ctrl .. 'w>-', '<C-w>|', { desc = 'Max out width' })
end

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

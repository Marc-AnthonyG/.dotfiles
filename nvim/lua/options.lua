-- [[ Setting options ]]
-- See `:help vim.o`

-- Change thing that get doesn't get displayed
vim.opt.conceallevel = 2

vim.o.hlsearch = false -- Set highlight after search

vim.wo.relativenumber = true

vim.o.colorcolumn = '80'

vim.o.mouse = 'a' -- Enable mouse mode

vim.o.clipboard = 'unnamedplus' -- sync clipboard to OS See `:help 'clipboard'`

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.softtabstop = 4

vim.api.nvim_create_autocmd('FileType', {
	pattern = {
		'javascript',
		'typescript',
		'javascriptreact',
		'typescriptreact',
		'json',
		'html',
		'css',
		'lua',
	},
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.expandtab = true
	end,
})

vim.opt.confirm = true

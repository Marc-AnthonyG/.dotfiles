local M = {}

local function get_opts(name)
	local plugin = require('plugins')[name]
	if not plugin then
		return {}
	end
	return plugin.values(plugin, 'opts', false)
end

local function merge_tables(...)
	local result = {}
	for _, tbl in ipairs({ ... }) do
		for k, v in pairs(tbl) do
			result[k] = v
		end
	end
	return result
end

function M.get_clients(opts)
	local ret = {}
	if vim.lsp.get_clients then
		ret = vim.lsp.get_clients(opts)
	else
		---@diagnostic disable-next-line: deprecated
		ret = vim.lsp.get_active_clients(opts)
		if opts and opts.method then
			ret = vim.tbl_filter(function(client)
				return client.supports_method(opts.method, { bufnr = opts.bufnr })
			end, ret)
		end
	end
	return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

M._supports_method = {}

function M.on_supports_method(method, fn)
	M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = 'k' })
	return vim.api.nvim_create_autocmd('User', {
		pattern = 'LspSupportsMethod',
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client and method == args.data.method then
				return fn(client, buffer)
			end
		end,
	})
end

local function realpath(path)
	if path == '' or path == nil then
		return nil
	end
	path = vim.uv.fs_realpath(path) or path
	return path
end

function M.rename_file()
	local buf = vim.api.nvim_get_current_buf()
	local old = assert(realpath(vim.api.nvim_buf_get_name(buf)))
	local root = assert(realpath(vim.uv.cwd()))
	assert(old:find(root, 1, true) == 1, 'File not in project root')

	local extra = old:sub(#root + 2)

	vim.ui.input({
		prompt = 'New File Name: ',
		default = extra,
		completion = 'file',
	}, function(new)
		if not new or new == '' or new == extra then
			return
		end
		new = root .. '/' .. new
		vim.fn.mkdir(vim.fs.dirname(new), 'p')
		M.on_rename(old, new, function()
			vim.fn.rename(old, new)
			vim.cmd.edit(new)
			vim.api.nvim_buf_delete(buf, { force = true })
			vim.fn.delete(old)
		end)
	end)
end

---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
	local changes = {
		files = { {
			oldUri = vim.uri_from_fname(from),
			newUri = vim.uri_from_fname(to),
		} },
	}

	local clients = M.get_clients()
	for _, client in ipairs(clients) do
		if client.supports_method('workspace/willRenameFiles') then
			local resp = client.request_sync('workspace/willRenameFiles', changes, 1000, 0)
			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
			end
		end
	end

	if rename then
		rename()
	end

	for _, client in ipairs(clients) do
		if client.supports_method('workspace/didRenameFiles') then
			client.notify('workspace/didRenameFiles', changes)
		end
	end
end

function M.formatter(opts)
	opts = opts or {}
	local filter = opts.filter or {}
	filter = type(filter) == 'string' and { name = filter } or filter
	local ret = {
		name = 'LSP',
		primary = true,
		priority = Util.format.LSP_PRIORITY,
		format = function(buf)
			M.format(merge_tables({}, filter, { bufnr = buf }))
		end,
		sources = function(buf)
			local clients = M.get_clients(merge_tables({}, filter, { bufnr = buf }))
			local ret = vim.tbl_filter(function(client)
				return client.supports_method('textDocument/formatting')
					or client.supports_method('textDocument/rangeFormatting')
			end, clients)
			return vim.tbl_map(function(client)
				return client.name
			end, ret)
		end,
	}
	return merge_tables(ret, opts)
end

function M.format(opts)
	opts = vim.tbl_deep_extend(
		'force',
		{},
		opts or {},
		get_opts('nvim-lspconfig').format or {},
		get_opts('conform.nvim').format or {}
	)
	opts.formatters = {}
	require('conform').format(opts)
end

return M

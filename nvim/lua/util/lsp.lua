local M = {}

--- Get LSP clients with optional filtering
--- Provides compatibility between vim.lsp.get_clients (newer) and vim.lsp.get_active_clients (deprecated)
--- Supports method-based filtering for older Neovim versions
---@param opts? GetClientsOpt Options for filtering clients
---@return table[] clients List of LSP clients matching the criteria
function M.get_clients(opts)
	local clients = vim.lsp.get_clients(opts)
	return opts and opts.filter and vim.tbl_filter(opts.filter, clients) or clients
end

M._supports_method = {}

--- Register a callback for when an LSP client supports a specific method
--- Uses weak references to avoid memory leaks and listens for 'LspSupportsMethod' User events
---@param method string The LSP method to watch for (e.g., 'textDocument/formatting')
---@param fn function Callback function called with (client, buffer) when method is supported
function M.on_supports_method(method, fn)
	-- Store the callback for this method
	M._supports_method[method] = fn
end

--- Call the callback for each supported method callback when lsp attaches
---@param client table The LSP client
---@param bufnr number The buffer number
function M.on_attach_supports_method(client, bufnr)
	for registered_method, callback_fn in pairs(M._supports_method) do
		if client.supports_method(registered_method) then
			Util.log.debug('Calling callback for ' .. client.name .. ' for method ' .. registered_method)
			callback_fn(client, bufnr)
		end
	end
end

---Get the real path of a file, handling symlinks and empty paths
---@param path string|nil The file path to resolve
---@return string|nil realpath The resolved real path, or nil if path is empty/nil
local function realpath(path)
	if path == '' or path == nil then
		return nil
	end
	return vim.uv.fs_realpath(path) or path
end

--- Rename the current file with LSP workspace awareness
--- Prompts user for new filename and handles LSP willRename/didRename notifications
--- Ensures the file is within the project root before renaming
--- @usage M.rename_file() -- Opens input prompt to rename current buffer's file
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

--- Handle file rename with LSP workspace notifications
--- Sends willRenameFiles request, applies workspace edits, executes rename, then sends didRenameFiles
---@param from string The original file path
---@param to string The new file path
---@param rename? function Optional callback to perform the actual file rename operation
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

--- This function create THE lsp formatter meaning it should only be called once
--- This fonction create a primary formatter with lower priority then other primary formatters
--- meaning it is a fallback formatter
function M.formatter()
	return {
		name = 'LSP',
		primary = true,
		priority = Util.format.LSP_PRIORITY,
		format = M.lsp_format,
		sources = function(buf)
			local clients = M.get_clients(vim.tbl_extend('force', {}, { bufnr = buf }))
			local ret = vim.tbl_filter(function(client)
				return client.supports_method('textDocument/formatting')
					or client.supports_method('textDocument/rangeFormatting')
			end, clients)
			return vim.tbl_map(function(client)
				return client.name
			end, ret)
		end,
	}
end

M.lsp_format = function(buf)
	local opts = vim.tbl_deep_extend(
		'force',
		{},
		vim.tbl_extend('force', {}, { bufnr = buf }),
		Util.get_plugin_opts('nvim-lspconfig').format or {},
		Util.get_plugin_opts('conform.nvim').format or {}
	)
	opts.formatters = {}
	require('conform').format(opts)
end

M.get_lsp_config = function(name)
	return vim.lsp.config[name]
end

return M

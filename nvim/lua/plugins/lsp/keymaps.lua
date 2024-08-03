local Local = {}

Local._keys = nil

function Local.get()
	if Local._keys then
		return Local._keys
	end
	-- stylua: ignore
	Local._keys = {
		{ "<leader>cl", "<cmd>LspInfo<cr>",                                                                     desc = "Lsp Info" },
		{ "gd",         function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition",            has = "definition" },
		{ "gr",         "<cmd>Telescope lsp_references<cr>",                                                    desc = "References",                 nowait = true },
		{ "gI",         function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
		{ "gy",         function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
		{ "gD",         vim.lsp.buf.declaration,                                                                desc = "Goto Declaration" },
		{ "K",          vim.lsp.buf.hover,                                                                      desc = "Hover" },
		{ "gK",         vim.lsp.buf.signature_help,                                                             desc = "Signature Help",             has = "signatureHelp" },
		{ "<c-k>",      vim.lsp.buf.signature_help,                                                             mode = "i",                          desc = "Signature Help", has = "signatureHelp" },
		{ "<leader>r",  vim.lsp.buf.rename,                                                                     desc = "Rename",                     has = "rename" },
		{ "<leader>ca", vim.lsp.buf.code_action,                                                                desc = "Code Action",                mode = { "n", "v" },     has = "codeAction" },
		{ "<leader>cc", vim.lsp.codelens.run,                                                                   desc = "Run Codelens",               mode = { "n", "v" },     has = "codeLens" },
		{ "<leader>cC", vim.lsp.codelens.refresh,                                                               desc = "Refresh & Display Codelens", mode = { "n" },          has = "codeLens" },
		{ "<leader>cR", Util.lsp.rename_file,                                                                   desc = "Rename File",                mode = { "n" },          has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
		-- { "<leader>cA", LazyVim.lsp.action.source,   desc = "Source Action",              has = "codeAction" },
	}

	return Local._keys
end

---@param method string|string[]
function Local.has(buffer, method)
	if type(method) == "table" then
		for _, m in ipairs(method) do
			if Local.has(buffer, m) then
				return true
			end
		end
		return false
	end
	method = method:find("/") and method or "textDocument/" .. method
	local clients = Util.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		if client.supports_method(method) then
			return true
		end
	end
	return false
end

function Local.resolve(buffer)
	local Keys = require("lazy.core.handler.keys")
	if not Keys.resolve then
		return {}
	end
	local spec = Local.get()
	local opts = Util.opts("nvim-lspconfig")
	local clients = Util.lsp.get_clients({ bufnr = buffer })
	for _, client in ipairs(clients) do
		local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
		vim.list_extend(spec, maps)
	end
	return Keys.resolve(spec)
end

function Local.on_attach(_, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = Local.resolve(buffer)

	for _, keys in pairs(keymaps) do
		local has = not keys.has or Local.has(buffer, keys.has)
		local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

		if has and cond then
			local opts = Keys.opts(keys)
			opts.cond = nil
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer
			vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
		end
	end
end

return Local

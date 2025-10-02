local M = {}

M.lsp = require('util.lsp')

M.format = require('util.format')

M.log = require('util.log')

M.cmp = require('util.cmp')

function M.get_plugin(name)
	return require('lazy.core.config').spec.plugins[name]
end

function M.get_plugin_opts(name)
	local plugin = M.get_plugin(name)
	if not plugin then
		return {}
	end
	local Plugin = require('lazy.core.plugin')
	return Plugin.values(plugin, 'opts', false)
end

function M.has_flag(flag)
	for _, arg in ipairs(vim.v.argv) do
		if arg == flag then
			return true
		end
	end
	return false
end

function M.setup()
	M.log.setup()
end

return M

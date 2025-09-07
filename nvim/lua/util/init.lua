local M = {}

M.lsp = require('util.lsp')

M.format = require('util.format')

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

return M

local M = {}

M.is_debug = false

function M.setup()
	M.is_debug = Util.has_flag('--debug') or Util.has_flag('-d')

	vim.api.nvim_create_user_command('DebugInfo', function()
		vim.notify(M.is_debug and 'Debug enabled' or 'Debug disabled', vim.log.levels.INFO)
	end, {})
end

return M

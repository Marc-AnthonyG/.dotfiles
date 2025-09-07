local M = {}

M.is_debug = false

function M.setup()
	M.is_debug = Util.has_flag('--debug') or Util.has_flag('-d')

	vim.api.nvim_create_user_command('DebugInfo', function()
		vim.notify(M.is_debug and 'Debug enabled' or 'Debug disabled', vim.log.levels.INFO)
	end, {})
end

--- Displays the message only if nvim was started with the `--debug` flag.
---@param msg string Content of the notification to show to the user.
---@param opts table|nil Optional parameters. Unused by default.
function M.debug(msg, opts)
	if not M.is_debug then
		return
	end
	vim.notify(msg, vim.log.levels.DEBUG, opts)
end

--- Displays the message only if nvim was started with the `--debug` flag.
---@param msg string Content of the notification to show to the user.
---@param opts table|nil Optional parameters. Unused by default.
function M.info(msg, opts)
	vim.notify(msg, vim.log.levels.INFO, opts)
end

return M

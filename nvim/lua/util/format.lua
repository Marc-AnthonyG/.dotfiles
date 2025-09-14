local M = setmetatable({}, {
	__call = function(m, ...)
		return m.format(...)
	end,
})

--- @type FormatterProvider[]
M.formatters = {}

M.LSP_PRIORITY = 5
M.CONFORM_PRIORITY = 10
M.LSP_PRIORITY_FORMATTERS = 15

--- Register a formatter and sort them based on priority where higher = more priority
--- @param formatter FormatterProvider The formatter to register, must have a priority field
function M.register(formatter)
	M.formatters[#M.formatters + 1] = formatter
	table.sort(M.formatters, function(a, b)
		return a.priority > b.priority
	end)
end

--- Resolve the active formatters for the current buffer or the given buffer
--- This function will return only the highest priority "primary" formatters.
--- Multiple non-primary formatters will be returned if they are available.
---
--- Combine with the priority system when registering formatters this will give the primary formatters with the highest priority
---
---@param buf? number
---@return Formatter[]
function M.resolve(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local have_primary = false
	return vim.tbl_map(function(formatter)
		local sources = formatter.sources(buf)
		local active = #sources > 0 and (not formatter.primary or not have_primary)
		have_primary = have_primary or (active and formatter.primary) or false
		return setmetatable({
			active = active,
			resolved = sources,
		}, { __index = formatter })
	end, M.formatters)
end

--- Print the current status of the formatters for the current buffer
--- @param buf? number
function M.info(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	local gaf = vim.g.autoformat == nil or vim.g.autoformat
	local baf = vim.b[buf].autoformat
	local enabled = M.enabled(buf)
	local lines = {
		'# Status',
		('- [%s] global **%s**'):format(gaf and 'x' or ' ', gaf and 'enabled' or 'disabled'),
		('- [%s] buffer **%s**'):format(
			enabled and 'x' or ' ',
			baf == nil and 'inherit' or baf and 'enabled' or 'disabled'
		),
	}
	local have = false
	for _, formatter in ipairs(M.resolve(buf)) do
		if #formatter.resolved > 0 then
			have = true
			lines[#lines + 1] = '\n# ' .. formatter.name .. (formatter.active and ' ***(active)***' or '')
			for _, line in ipairs(formatter.resolved) do
				lines[#lines + 1] = ('- [%s] **%s**'):format(formatter.active and 'x' or ' ', line)
			end
		end
	end
	if not have then
		lines[#lines + 1] = '\n***No formatters available for this buffer.***'
	end
	vim.notify(
		table.concat(lines, '\n'),
		vim.log.levels.INFO,
		{ title = 'Format Info! (' .. (enabled and 'enabled' or 'disabled') .. ')' }
	)
end

--- Check if formatting is enabled for a buffer.
--- Uses a hierarchical configuration system where buffer-local settings
--- take precedence over global settings, with a default of enabled.
---
--- Configuration precedence (highest to lowest):
--- 1. Buffer-local: vim.b[buf].autoformat
--- 2. Global: vim.g.autoformat
--- 3. Default: true (enabled)
---
--- @param buf? number Buffer handle, defaults to current buffer if nil or 0
--- @return boolean enabled True if formatting is enabled for the buffer
function M.enabled(buf)
	-- Use given buffer or default to current buffer
	buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
	local gaf = vim.g.autoformat
	local baf = vim.b[buf].autoformat

	-- If the buffer has a local value, use that
	if baf ~= nil then
		return baf
	end

	-- Otherwise use the global value if set, or true by default
	return gaf == nil or gaf
end

--- Format the current buffer or specified buffer using the first active formatter
---
--- This function finds the highest priority active formatter and applies it to the buffer.
--- Formatting only occurs if enabled for the buffer or if forced via options.
--- Only the first active formatter is used (single formatter execution).
---
--- @param opts? FormatOpt
--- @return any|nil result The result from the formatter, or nil if no formatting occurred
function M.format(opts)
	opts = opts or {}
	local buf = opts.buf or vim.api.nvim_get_current_buf()
	if not ((opts and opts.force) or M.enabled(buf)) then
		return
	end

	local has_formated_once = false
	for _, formatter in ipairs(M.resolve(buf)) do
		if formatter.active then
			Util.log.debug('Formatting with ' .. formatter.name)
			local ok, result = pcall(formatter.format, buf)
			if ok then
				Util.log.debug('Format was successful')
			else
				vim.notify(('Formatter failed: %s'):format(result), vim.log.levels.ERROR, { title = formatter.name })
				return
			end
		end
	end

	if not has_formated_once and opts and opts.force then
		vim.health.warn('No formatter available', { title = 'Format' })
	end
end

return M

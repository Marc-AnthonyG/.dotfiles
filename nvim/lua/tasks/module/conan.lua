local Path = require('plenary.path')
local ProjectConfig = require('tasks.project_config')

local conan = {}

--- Parses build dir expression.
---@param dir string: Path with expressions to replace.
---@param build_type string
---@return table
local function parse_dir(dir, build_type)
	local parsed_dir = dir:gsub('{cwd}', vim.uv.cwd())
	parsed_dir = parsed_dir:gsub('{os}', os)
	parsed_dir = parsed_dir:gsub('{build_type}', build_type:lower())
	return Path:new(parsed_dir)
end



---@param module_config table
---@return table?
local function install(module_config, _)
	local build_dir = parse_dir(module_config.build_dir, module_config.build_type)
	build_dir:mkdir({ parents = true })

	return {
		cmd = 'conan',
		args = { 'install', '.', '--build', 'missing', '--output-folder', build_dir.filename, '-pr', module_config.profile, '-s', 'build_type', module_config.build_type },
		ignore_stdout = false,
		ignore_stderr = false,
	}
end

-- A table of parameter names. Possible values:
conan.params = {
	build_type = { 'Debug', 'Release' },
	'build_dir',
	profile = { 'default' },
}
-- A function that returns `true` if this module could be applied to this directory. Used when `auto` is used as module name.
conan.condition = function() return true end

conan.tasks = {
	install = install
}

return conan

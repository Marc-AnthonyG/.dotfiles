return {
	"Shatur/neovim-tasks",
	init = function()
		local Path = require('plenary.path')
		require('tasks').setup({
			default_params = {
				cmake = {
					cmd = 'cmake',
					build_dir = tostring(Path:new('{cwd}', 'build')),
					build_type = 'Debug',
					dap_name = 'codelldb',
				},
			},
			save_before_run = true,
			dap_open_command = function() return require('dap').repl.open() end
		})
	end,
}

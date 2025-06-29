-- [[ Configure NeoTest ]]
return {
	'nvim-neotest/neotest',
	version = '*',
	dependencies = {
		'nvim-neotest/nvim-nio',
		'nvim-lua/plenary.nvim',
		'antoinemadec/FixCursorHold.nvim',
		'nvim-treesitter/nvim-treesitter',

		-- [[ Adaptater dependencies ]]
		'nvim-neotest/neotest-jest',
	},
	opts = {
		adapters = {
			['neotest-jest'] = {
				jestCommand = 'npm test --',
				env = { CI = true },
				cwd = function()
					return vim.fn.getcwd()
				end,
			},
		},
		status = { virtual_text = true },
		output = { open_on_run = true },
		quickfix = {
			open = function()
				require('trouble').open({ mode = 'quickfix', focus = false })
			end,
		},
	},
	config = function(_, opts)
		local neotest_ns = vim.api.nvim_create_namespace('neotest')
		vim.diagnostic.config({
			virtual_text = {
				format = function(diagnostic)
					local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
					return message
				end,
			},
		}, neotest_ns)

		opts.consumers = opts.consumers or {}

		opts.consumers.trouble = function(client)
			client.listeners.results = function(adapter_id, results, partial)
				if partial then
					return
				end
				local tree = assert(client:get_position(nil, { adapter = adapter_id }))

				local failed = 0
				for pos_id, result in pairs(results) do
					if result.status == 'failed' and tree:get_key(pos_id) then
						failed = failed + 1
					end
				end
				vim.schedule(function()
					local trouble = require('trouble')
					if trouble.is_open() then
						trouble.refresh()
						if failed == 0 then
							trouble.close()
						end
					end
				end)
				return {}
			end
		end

		if opts.adapters then
			local adapters = {}
			for name, config in pairs(opts.adapters or {}) do
				if type(name) == 'number' then
					if type(config) == 'string' then
						config = require(config)
					end
					adapters[#adapters + 1] = config
				elseif config ~= false then
					local adapter = require(name)
					if type(config) == 'table' and not vim.tbl_isempty(config) then
						local meta = getmetatable(adapter)
						if adapter.setup then
							adapter.setup(config)
						elseif adapter.adapter then
							adapter.adapter(config)
							adapter = adapter.adapter
						elseif meta and meta.__call then
							adapter(config)
						else
							error('Adapter ' .. name .. ' does not support setup')
						end
					end
					adapters[#adapters + 1] = adapter
				end
			end
			opts.adapters = adapters
		end

		require('neotest').setup(opts)
	end,
	keys = {
		{
			'<leader>t',
			'',
			desc = '+test',
		},
		{
			'<leader>ta',
			function()
				require('neotest').run.run(vim.fn.expand('%'))
			end,
			desc = 'run [a]ll in file',
		},
		{
			'<leader>tA',
			function()
				require('neotest').run.run(vim.uv.cwd())
			end,
			desc = 'run [A]ll Test Files',
		},
		{
			'<leader>tn',
			function()
				require('neotest').run.run()
			end,
			desc = 'run [n]earest',
		},
		{
			'<leader>tl',
			function()
				require('neotest').run.run_last()
			end,
			desc = 'run [l]ast',
		},
		{
			'<leader>ts',
			function()
				require('neotest').summary.toggle()
			end,
			desc = 'toggle [S]ummary',
		},
		{
			'<leader>to',
			function()
				require('neotest').output.open({ enter = true, auto_close = true })
			end,
			desc = 'show [o]utput',
		},
		{
			'<leader>tO',
			function()
				require('neotest').output_panel.toggle()
			end,
			desc = 'toggle [O]utput panel',
		},
		{
			'<leader>tS',
			function()
				require('neotest').run.stop()
			end,
			desc = '[S]top',
		},
		{
			'<leader>tw',
			function()
				require('neotest').watch.toggle(vim.fn.expand('%'))
			end,
			desc = 'toggle [W]atch',
		},
	},
}

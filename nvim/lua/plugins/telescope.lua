return {
	'nvim-telescope/telescope.nvim',
	version = '*',
	dependencies = { -- require make
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable('make') == 1
			end,
		},
	},
	config = function()
		require('telescope').setup({
			defaults = {
				mappings = {
					i = {
						['<C-u>'] = false,
						['<C-d>'] = false,
					},
				},
				path_display = {
					'truncate',
				},
			},
		})
		pcall(require('telescope').load_extension, 'fzf')

		-- Telescope live_grep in git root
		-- Function to find the git root directory based on the current buffer's path
		local function find_git_root()
			-- Use the current buffer's path as the starting point for the git search
			local current_file = vim.api.nvim_buf_get_name(0)
			local current_dir
			local cwd = vim.fn.getcwd()
			-- If the buffer is not associated with a file, return nil
			if current_file == '' then
				current_dir = cwd
			else
				-- Extract the directory from the current file's path
				current_dir = vim.fn.fnamemodify(current_file, ':h')
			end

			-- Find the Git root directory from the current file's path
			local git_root =
				vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
			if vim.v.shell_error ~= 0 then
				print('Not a git repository. Searching on current working directory')
				return cwd
			end
			return git_root
		end

		-- Custom live_grep function to search in git root
		local function live_grep_git_root()
			local git_root = find_git_root()
			if git_root then
				require('telescope.builtin').live_grep({
					search_dirs = { git_root },
				})
			end
		end

		vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

		vim.keymap.set(
			'n',
			'<leader>?',
			require('telescope.builtin').oldfiles,
			{ desc = '[?] Find recently opened files' }
		)
		vim.keymap.set(
			'n',
			'<leader>sb',
			require('telescope.builtin').buffers,
			{ desc = '[ ] [Search] existing [B]uffers' }
		)
		vim.keymap.set('n', '<leader>/', function()
			require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
				winblend = 10,
				previewer = true,
			}))
		end, { desc = '[/] Fuzzily search in current buffer' })

		vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').git_files, { desc = 'Search [G]it Files' })
		vim.keymap.set('n', '<leader>g', require('telescope.builtin').find_files, { desc = '[S]earch [G]lobal Files' })
		vim.keymap.set({ 'n', 'v' }, '<leader>s', '', { desc = '[S]earch' })
		vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set(
			'n',
			'<leader>sw',
			require('telescope.builtin').grep_string,
			{ desc = '[S]earch current [W]ord' }
		)
		vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
		vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
		vim.keymap.set('n', '<leader>sR', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
	end,
}

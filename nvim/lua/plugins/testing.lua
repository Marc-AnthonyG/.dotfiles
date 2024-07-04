-- [[ Configure NeoTest ]]
return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",

        -- [[ Adaptater dependencies ]]
        "nvim-neotest/neotest-jest",
    },
    config = function()
        local neotest = require('neotest')

        neotest.setup({
            adapters = {
                require('neotest-jest')({
                    jestCommand = "npm test --",
                    env = { CI = true },
                    cwd = function(path)
                        return vim.fn.getcwd()
                    end,
                }),
            }
        })
    end,
    keys = {
        { "<leader>t",  "",                                                                                 desc = "+test" },
        { "<leader>ta", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "run [a]ll in file" },
        { "<leader>tA", function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "run [A]ll Test Files" },
        { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "run nea[r]est" },
        { "<leader>tl", function() require("neotest").run.run_last() end,                                   desc = "run [l]ast" },
        { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "toggle [S]ummary" },
        { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "show [o]utput" },
        { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "toggle [O]utput panel" },
        { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "[S]top" },
        { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "toggle [W]atch" },
    },
}

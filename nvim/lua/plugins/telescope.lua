return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        "nvim-telescope/telescope-dap.nvim",
        "debugloop/telescope-undo.nvim",
        { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    config = function()
        local telescope = require("telescope")
        local lga_actions = require("telescope-live-grep-args.actions")

        telescope.setup({
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                undo = {
                    side_by_side = true,
                    layout_strategy = "vertical",
                    layout_config = { preview_height = 0.8 },
                },
                live_grep_args = {
                    auto_quoting = true,
                    mappings = {
                        i = {
                            ["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                        },
                    },
                },
            },
        })

        if vim.loop.os_uname().sysname ~= "Windows_NT" then
            telescope.load_extension("fzf")
        end
        telescope.load_extension("dap")
        telescope.load_extension("undo")
        telescope.load_extension("live_grep_args")

        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
        vim.keymap.set("n", "<leader>fc", function()
            builtin.find_files({ hidden = true })
        end, { desc = "Find Config Files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
        vim.keymap.set("n", "<leader>km", builtin.keymaps, { desc = "Keymaps" })
        vim.keymap.set("n", "<leader>;", builtin.buffers, { desc = "Buffers" })
        vim.keymap.set("n", "<leader>?", builtin.oldfiles, { desc = "Recently opened files" })
        vim.keymap.set("n", "<leader>/", function()
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
            }))
        end, { desc = "Search in current buffer" })

        vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
        vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>", { desc = "Undo History" })
        vim.keymap.set("n", "<leader>db", "<cmd>Telescope dap list_breakpoints<cr>", { desc = "DAP Breakpoints" })
        vim.keymap.set("n", "<leader>dv", "<cmd>Telescope dap variables<cr>", { desc = "DAP Variables" })
        vim.keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<cr>", { desc = "DAP Frames" })

        vim.keymap.set("n", "<leader>sa", function()
            require("telescope").extensions.live_grep_args.live_grep_args()
        end, { desc = "Grep with Args" })
    end,
}

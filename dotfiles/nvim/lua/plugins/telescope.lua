return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { 
            'nvim-telescope/telescope-fzf-native.nvim', 
            build = "make",
        },
        "nvim-dap",
        "nvim-telescope/telescope-dap.nvim",
        "debugloop/telescope-undo.nvim",
        { "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
    },
    config = function()
        local telescope = require('telescope')
        local lga_actions = require("telescope-live-grep-args.actions")

        telescope.setup {
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
                    layout_config = {
                        preview_height = 0.8,
                    },
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
            }
        }

        -- =========================================
        -- 加载扩展 (Extension Loading)
        -- =========================================
        if vim.loop.os_uname().sysname ~= "Windows_NT" then
            telescope.load_extension('fzf')
        end

        -- 2. 加载其他新扩展
        telescope.load_extension('dap')            -- 调试
        telescope.load_extension('undo')           -- 撤销历史
        telescope.load_extension('live_grep_args') -- 高级搜索

        -- =========================================
        -- 按键映射 (Keymaps)
        -- =========================================
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
        vim.keymap.set('n', '<leader>fc', function() builtin.find_files({ hidden = true }) end, { desc = 'Find Config Files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
        vim.keymap.set('n', '<leader>km', builtin.keymaps, { desc = 'Keymaps' })
        vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = 'Buffers' })
        vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader>/', function()
            require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                winblend = 10,
                previewer = false,
            })
        end, { desc = '[/] Fuzzily search in current buffer' })

        vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Git Branches' })
        vim.keymap.set('n', '<leader>u', "<cmd>Telescope undo<cr>", { desc = 'Undo History' })

        vim.keymap.set('n', '<leader>sa', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = 'Grep with Args' })

        vim.keymap.set('n', '<leader>db', "<cmd>Telescope dap list_breakpoints<cr>", { desc = 'DAP Breakpoints' })
        vim.keymap.set('n', '<leader>dv', "<cmd>Telescope dap variables<cr>", { desc = 'DAP Variables' })
        vim.keymap.set('n', '<leader>df', "<cmd>Telescope dap frames<cr>", { desc = 'DAP Frames' })

        -- 这会打开一个列表，列出你所有访问过的项目（包含 .git 或 go.mod 的文件夹）
        vim.keymap.set('n', '<leader>fp', "<cmd>Telescope projects<cr>", { desc = 'Switch Projects' })
    end
}

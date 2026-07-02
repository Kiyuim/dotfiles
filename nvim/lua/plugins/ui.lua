return {
    -- Bufferline (tabs at top)
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        config = true,
    },
    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },
    -- Git signs in gutter (blame, hunk nav, etc.)
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = true,
    },
    -- Highlight same word under cursor
    {
        "RRethy/vim-illuminate",
        event = "VeryLazy",
        config = function()
            require("illuminate").configure()
        end,
    },
    -- Pretty notifications
    {
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss({ silent = true, pending = true })
                end,
                desc = "Dismiss all Notifications",
            },
        },
        opts = {
            timeout = 3000,
            max_height = function() return math.floor(vim.o.lines * 0.75) end,
            max_width = function() return math.floor(vim.o.columns * 0.75) end,
            on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 100 }) end,
        },
        init = function()
            vim.notify = require("notify")
        end,
    },
    -- File tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree", mode = { "n", "v" } },
        },
        config = true,
    },
    -- Alpha dashboard (startup screen)
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            local logo = [[
        ⠀⠀⠀⢀⣀⣤⣤⣤⣤⣄⡀⠀⠀⠀⠀
        ⠀⢀⣤⣾⣿⣾⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀
        ⢠⣾⣿⢛⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀
        ⣾⣯⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
        ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
        ⣿⡿⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠻⢿⡵
        ⢸⡇⠀⠀⠉⠛⠛⣿⣿⠛⠛⠉⠀⠀⣿⡇
        ⢸⣿⣀⠀⢀⣠⣴⡇⠹⣦⣄⡀⠀⣠⣿⡇
        ⠈⠻⠿⠿⣟⣿⣿⣦⣤⣼⣿⣿⠿⠿⠟⠀
        ⠀⠀⠀⠀⠸⡿⣿⣿⢿⡿⢿⠇⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠀⠈⠁⠈⠁⠀⠀⠀⠀⠀⠀
                        _
  _ __    ___   _____   _(_)_ __ ___
 | '_ \ / _ \/ _ \ \ / / | '_ ` _ \
 | | | |  __/ (_) \ V /| | | | | | |
 |_| |_|\___|\___/ \_/ |_|_| |_| |_|
    ]]

            dashboard.section.header.val = vim.split(logo, "\n")

            local datetime = os.date("📅 %Y-%m-%d  🕒 %H:%M:%S")
            dashboard.section.date = {
                type = "text",
                val = datetime,
                opts = { position = "center", hl = "Number" },
            }

            dashboard.section.quote = {
                type = "text",
                val = "🔥 Pain + Reflection = Progress 🚀",
                opts = { position = "center", hl = "Constant" },
            }

            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", "<cmd> Telescope find_files <cr>"),
                dashboard.button("p", " " .. " Project Config", "<cmd> Telescope find_files hidden=true <cr>"),
                dashboard.button("c", " " .. " Nvim Config", "<cmd> Telescope find_files cwd=" .. vim.fn.stdpath("config") .. " <cr>"),
                dashboard.button("n", " " .. " New file", [[<cmd> ene <BAR> startinsert <cr>]]),
                dashboard.button("r", " " .. " Recent files", [[<cmd> Telescope oldfiles <cr>]]),
                dashboard.button("g", " " .. " Find text", [[<cmd> Telescope live_grep <cr>]]),
                dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
                dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
                dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
            }

            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end

            vim.cmd("hi AlphaHeader guifg=#FEBA17")
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"

            dashboard.config.layout = {
                { type = "padding", val = 2 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.date,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 2 },
                dashboard.section.quote,
                dashboard.section.footer,
            }

            return dashboard
        end,
        config = function(_, dashboard)
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    once = true,
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                once = true,
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded "
                        .. stats.loaded .. "/" .. stats.count
                        .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
    -- Which-key help
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = true,
    },
}

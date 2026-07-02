return {
    -- Tmux/vim seamless navigation
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    -- Session persistence
    {
        "folke/persistence.nvim",
        keys = {
            { "<leader>qs", [[<cmd>lua require("persistence").load()<cr>]], desc = "Load session" },
            { "<leader>ql", [[<cmd>lua require("persistence").load({ last = true})<cr>]], desc = "Load last session" },
            { "<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]], desc = "Stop persistence" },
        },
        config = true,
    },
    -- Auto pairs (brackets, quotes, etc.)
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        opts = { enable_check_bracket_line = false },
    },
    -- Restore cursor position on reopen
    {
        "ethanholz/nvim-lastplace",
        config = true,
    },
    -- Fast jump (replaces EasyMotion)
    {
        "folke/flash.nvim",
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
            { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
            { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash TS Search" },
        },
        config = true,
    },
    -- Enhanced text objects (ia, aa, etc.)
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        config = true,
    },
    -- Quick commenting (gcc, gc)
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        config = true,
    },
    -- Surround (ys, ds, cs)
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end,
    },
}

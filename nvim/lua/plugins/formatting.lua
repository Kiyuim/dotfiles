return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "zapling/mason-conform.nvim",
    },
    config = function()
        local conform = require("conform")

        require("mason-conform").setup({
            ensure_installed = {
                "stylua",
                "gofumpt",
                "goimports-reviser",
                "prettier",
                "shfmt",
            },
        })

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "goimports-reviser", "gofumpt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                bash = { "shfmt" },
            },
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 500,
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>hf", function()
            conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
        end, { desc = "Format file or range" })
    end,
}

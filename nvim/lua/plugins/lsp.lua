return {
    "neovim/nvim-lspconfig",
    cmd = { "Mason", "Neoconf" },
    lazy = false,
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig",
        "folke/neoconf.nvim",
        "folke/lazydev.nvim",
        { "j-hui/fidget.nvim", tag = "legacy" },
        "nvimdev/lspsaga.nvim",
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        require("neoconf").setup()
        require("lazydev").setup()
        require("fidget").setup()
        require("lspsaga").setup({ ui = { border = "rounded" } })
        require("mason").setup()

        local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
                vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
            end

            nmap("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
            nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
            nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
            nmap("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
            nmap("K", "<cmd>Lspsaga hover_doc<CR>", "Hover Documentation")
            nmap("<leader>ca", "<cmd>Lspsaga code_action<CR>", "[C]ode [A]ction")
            nmap("<leader>rn", "<cmd>Lspsaga rename ++project<cr>", "[R]e[n]ame")
            nmap("<leader>da", "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostics")
            nmap("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", "Prev Diagnostic")
            nmap("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", "Next Diagnostic")
            nmap("<space>f", function() vim.lsp.buf.format({ async = true }) end, "[F]ormat code")
        end

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.offsetEncoding = { "utf-16" }

        -- Rust + Go + essentials
        local servers = {
            rust_analyzer = {}, -- handled by rustaceanvim
            gopls = {},
            lua_ls = {},
            jsonls = {},
            bashls = {},
            dockerls = {},
            taplo = {},
        }

        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers),
            handlers = {
                function(server_name)
                    if server_name == "rust_analyzer" then
                        return -- rustaceanvim handles this
                    end

                    require("lspconfig")[server_name].setup({
                        settings = servers[server_name],
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,

                ["gopls"] = function()
                    require("lspconfig").gopls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            gopls = {
                                usePlaceholders = true,
                                analyses = { unusedparams = true },
                                staticcheck = true,
                            },
                        },
                    })
                end,

                ["lua_ls"] = function()
                    require("lspconfig").lua_ls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                workspace = { checkThirdParty = false },
                                telemetry = { enable = false },
                            },
                        },
                    })
                end,
            },
        })
    end,
}

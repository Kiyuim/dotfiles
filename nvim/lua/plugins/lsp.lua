return {
    "neovim/nvim-lspconfig",
    cmd = { "Mason", "Neoconf" },
    -- event = { "BufReadPost", "BufNewFile" },
    lazy = false,
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig",
        "folke/neoconf.nvim",
        "folke/lazydev.nvim", -- Lua 开发神器
        { "j-hui/fidget.nvim", tag = "legacy" },
        "nvimdev/lspsaga.nvim",
        "hrsh7th/cmp-nvim-lsp",
        -- [Java 核心] 必须加载
        "nvim-java/nvim-java",
    },
    config = function()
        -- 1. [关键] Java 初始化必须放在最前面
        require('java').setup()

        -- 2. 初始化其他 UI 和工具
        require("neoconf").setup()
        require("lazydev").setup()
        require("fidget").setup()
        require("lspsaga").setup({
            ui = { border = "rounded" },
        })
        require("mason").setup()

        -- 3. 定义按键映射
        local on_attach = function(_, bufnr)
            local nmap = function(keys, func, desc)
                if desc then desc = 'LSP: ' .. desc end
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('gd', require "telescope.builtin".lsp_definitions, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', require "telescope.builtin".lsp_implementations, '[G]oto [I]mplementation')
            nmap('<leader>D', require "telescope.builtin".lsp_type_definitions, 'Type [D]efinition')
            nmap('K', "<cmd>Lspsaga hover_doc<CR>", 'Hover Documentation')
            nmap('<leader>ca', "<cmd>Lspsaga code_action<CR>", '[C]ode [A]ction')
            nmap('<leader>rn', "<cmd>Lspsaga rename ++project<cr>", '[R]e[n]ame')
            nmap('<leader>da', "<cmd>Lspsaga show_line_diagnostics<CR>", 'Line Diagnostics')
            nmap('[d', "<cmd>Lspsaga diagnostic_jump_prev<CR>", 'Prev Diagnostic')
            nmap(']d', "<cmd>Lspsaga diagnostic_jump_next<CR>", 'Next Diagnostic')
            nmap("<space>f", function() vim.lsp.buf.format { async = true } end, "[F]ormat code")
        end

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.offsetEncoding = { "utf-16" }

        -- 4. 定义需要安装的服务器
        local servers = {
            -- Web3 / 区块链
            solidity_ls_nomicfoundation = {}, 
            
            -- Rust (注意：这里只负责让 Mason 下载它，配置交给 rustaceanvim)
            rust_analyzer = {}, 

            -- 后端全栈
            jdtls = {},     -- Java
            gopls = {},     -- Go
            buf_ls = {},     -- ProtoBuf
            pyright = {},   -- Python

            -- 基础/算法
            clangd = {},    -- C++
            lua_ls = {},    -- Lua
            jsonls = {},
            bashls = {},
            dockerls = {},
            taplo = {},     -- TOML (Rust 配置文件)
            ruff = {},
        }

        -- 5. Mason 配置与 Handlers
        require("mason-lspconfig").setup({
            ensure_installed = vim.tbl_keys(servers),
            handlers = {
                -- A. 默认 Handler (处理大多数服务器)
                function(server_name)
                    -- [CRITICAL] 忽略 rust_analyzer，交给 rustaceanvim 插件处理
                    if server_name == "rust_analyzer" then
                        return
                    end

                    require("lspconfig")[server_name].setup {
                        settings = servers[server_name],
                        on_attach = on_attach,
                        capabilities = capabilities,
                    }
                end,

                -- B. Java (由 nvim-java 接管)
                ["jdtls"] = function()
                    require("lspconfig").jdtls.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                    })
                end,

                -- C. Go (开启更多静态分析)
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

                -- D. Lua (优化配置)
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

                -- E. C++ (极简配置)
                ["clangd"] = function()
                     require("lspconfig").clangd.setup({
                        on_attach = on_attach,
                        capabilities = capabilities,
                        cmd = { "clangd", "--offset-encoding=utf-16" },
                     })
                end,
            }
        })
    end
}

return {
    "mrcjkb/rustaceanvim",
    version = "^5", -- 建议锁定大版本
    lazy = false,   -- 必须随文件类型加载，不能 Lazy
    init = function()
        -- 配置 rustaceanvim
        vim.g.rustaceanvim = {
            -- LSP 设置
            server = {
                on_attach = function(client, bufnr)
                    -- 绑定 K 键为 Rust 专属的悬停操作 (支持操作 Link)
                    vim.keymap.set("n", "K", function() 
                        vim.cmd.RustLsp({'hover', 'actions'}) 
                    end, { buffer = bufnr })
                    
                    -- 绑定 <leader>ca 为 Rust 专属的代码操作 (分组更合理)
                    vim.keymap.set("n", "<leader>ca", function() 
                        vim.cmd.RustLsp('codeAction') 
                    end, { buffer = bufnr })
                end,
            },
            -- DAP 设置 (自动适配 Mason 下载的 codelldb)
            dap = {
                autoload_configurations = true,
            },
        }
    end
}

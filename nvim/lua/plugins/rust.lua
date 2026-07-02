return {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    dependencies = {
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
    },
    init = function()
        vim.g.rustaceanvim = {
            server = {
                on_attach = function(_, bufnr)
                    vim.keymap.set("n", "K", function()
                        vim.cmd.RustLsp({ "hover", "actions" })
                    end, { buffer = bufnr, desc = "Rust Hover Actions" })

                    vim.keymap.set("n", "<leader>ca", function()
                        vim.cmd.RustLsp("codeAction")
                    end, { buffer = bufnr, desc = "Rust Code Action" })
                end,
            },
            dap = {
                autoload_configurations = true,
            },
        }
    end,
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("nvim-dap-virtual-text").setup()
        dapui.setup()

        -- Auto open/close DAP UI
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- Mason: install codelldb for Rust debugging
        require("mason-nvim-dap").setup({
            ensure_installed = { "codelldb" },
            automatic_installation = true,
        })

        -- DAP keymaps
        local map = vim.keymap.set
        map("n", "<F5>", function() dap.continue() end, { desc = "Debug: Start/Continue" })
        map("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
        map("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
        map("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step Out" })
        map("n", "<leader>bb", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
        map("n", "<leader>bB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Conditional Breakpoint" })
        map("n", "<leader>dr", function() dap.repl.open() end, { desc = "Debug: Open REPL" })
        map("n", "<leader>dl", function() dap.run_last() end, { desc = "Debug: Run Last" })

        -- Cargo shortcuts
        map("n", "<leader>cb", function() vim.cmd("terminal cargo build") end, { desc = "Cargo Build" })
        map("n", "<leader>cB", function() vim.cmd("terminal cargo build --release") end, { desc = "Cargo Build --release" })
        map("n", "<leader>cr", function() vim.cmd("terminal cargo run") end, { desc = "Cargo Run" })
        map("n", "<leader>ct", function() vim.cmd("terminal cargo test") end, { desc = "Cargo Test" })
        map("n", "<leader>cc", function() vim.cmd("terminal cargo check") end, { desc = "Cargo Check" })
        map("n", "<leader>cl", function() vim.cmd("terminal cargo clippy") end, { desc = "Cargo Clippy" })
        map("n", "<leader>cu", function() vim.cmd("terminal cargo update") end, { desc = "Cargo Update" })
    end,
}

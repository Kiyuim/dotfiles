return {
	"mfussenegger/nvim-dap",
	ft = { "go", "gomod", "rust", "c", "cpp", "java" },
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"theHamsta/nvim-dap-virtual-text",
		"nvim-telescope/telescope-dap.nvim",
		"nvim-neotest/nvim-nio", -- dap-ui 依赖
		"jay-babu/mason-nvim-dap.nvim", -- Mason 桥接
		"leoluz/nvim-dap-go", -- Go 调试增强
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<F12>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<Leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<Leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional Breakpoint",
		},
		{
			"<Leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Debug: Open REPL",
		},
		{
			"<Leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run Last",
		},
		{
			"<Leader>de",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "Debug: Clear All Breakpoints",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("nvim-dap-virtual-text").setup()
		dapui.setup()

		-- 自动开关调试窗口
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Mason-DAP: 确保下载 Go 和 Rust 的调试器
		require("mason-nvim-dap").setup({
			ensure_installed = { "delve", "codelldb" },
			automatic_installation = true,
		})

		-- 配置 Go 调试
		require("dap-go").setup({
			delve = {
				path = vim.fn.stdpath("data") .. "/mason/bin/dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
			},
		})

		-- 3. C++ 配置 (保留这个，因为 clangd 不会自动配 DAP)
		dap.adapters.codelldb = {
			type = "server",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
				args = { "--port", "${port}" },
			},
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}

		-- C 语言可以复用 C++
		dap.configurations.c = dap.configurations.cpp
	end,
}

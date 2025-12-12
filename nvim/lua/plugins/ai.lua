return {
	-- =============================================
	-- 1. Copilot 核心引擎 (负责代码补全/幽灵文本)
	-- =============================================
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter", -- 进入插入模式时才加载，不拖慢启动
		config = function()
			require("copilot").setup({
				-- 建议 (Ghost Text) 配置
				suggestion = {
					enabled = true,
					auto_trigger = true, -- 自动显示建议，不需要按快捷键
					debounce = 75, -- 延迟一点点，防闪烁
					keymap = {
						accept = "<C-j>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>", -- Alt + ] 切换下一个建议
						prev = "<M-[>", -- Alt + [ 切换上一个建议
						dismiss = "<C-]>", -- Ctrl + ] 忽略当前建议
					},
				},
				-- 面板配置 (比较少用，通常看 Ghost Text 就够了)
				panel = { enabled = false },

				-- 文件类型白名单
				filetypes = {
					yaml = true,
					markdown = true,
					help = false,
					gitcommit = true,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
			})
		end,
	},

	-- =============================================
	-- 2. Copilot Chat (负责对话/解释/写测试)
	-- =============================================
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- 依赖核心
			{ "nvim-lua/plenary.nvim" }, -- 基础依赖
		},
		-- 定义快捷键
		keys = {
			{
				"<leader>cc",
				function()
					return require("CopilotChat").toggle()
				end,
				desc = "Copilot Chat Toggle",
				mode = { "n", "v" },
			},
			{
				"<leader>ce",
				function()
					return require("CopilotChat").ask("Explain how it works")
				end,
				desc = "Copilot Explain",
				mode = { "n", "v" }, -- 支持普通模式和可视模式
			},
			{
				"<leader>ct",
				function()
					return require("CopilotChat").ask("Generate tests for my code")
				end,
				desc = "Copilot Tests",
				mode = { "n", "v" },
			},
			{
				"<leader>cr",
				function()
					return require("CopilotChat").ask("Review my code and give suggestions")
				end,
				desc = "Copilot Review",
				mode = { "n", "v" },
			},
			{
				"<leader>cf",
				function()
					return require("CopilotChat").ask("Fix the bug in this code")
				end,
				desc = "Copilot Fix",
				mode = { "n", "v" },
			},
		},
		config = function()
			require("CopilotChat").setup({
				debug = false, -- 关闭调试日志
				model = "gpt-4o",
				-- 窗口设置
				window = {
					layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
					width = 0.3, -- 窗口宽度 (30%)
					height = 0.5, -- 窗口高度
					relative = "editor",
					border = "single",
					row = nil,
					col = nil,
					title = "Copilot Chat",
					footer = nil,
					zindex = 1,
				},

				-- 系统提示词 (你可以让它扮演一个资深 Web3 开发者)
				system_prompt = "You are a senior developer experienced in Go, Rust, and Solidity. \n"
					.. "When asked to explain, explain clearly and concisely. \n"
					.. "When asked to write code, provide production-ready code.",

				-- 默认映射
				mappings = {
					complete = {
						detail = "Use @<Tab> or /<Tab> for options.",
						insert = "<Tab>",
					},
					close = {
						normal = "q",
						insert = "<C-c>",
					},
					reset = {
						normal = "<C-l>",
						insert = "<C-l>",
					},
					submit_prompt = {
						normal = "<CR>",
						insert = "<C-CR>", -- Windows/Linux 下可能是 <C-m>
					},
					accept_diff = {
						normal = "<C-y>",
						insert = "<C-y>",
					},
					yank_diff = {
						normal = "gy",
					},
					show_diff = {
						normal = "gd",
					},
					show_system_prompt = {
						normal = "gp",
					},
					show_user_selection = {
						normal = "gs",
					},
				},
			})
		end,
	},
}

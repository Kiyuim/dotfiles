return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" }, -- 打开文件时加载
	dependencies = {
		"williamboman/mason.nvim",
		"zapling/mason-conform.nvim",
	},
	config = function()
		local conform = require("conform")

		-- 1. 配置 Mason-Conform (自动安装格式化工具)
		require("mason-conform").setup({
			-- 确保这些工具被自动安装
			ensure_installed = {
				"stylua", -- Lua
				"gofumpt", -- Go (更严格的 gofmt)
				"goimports-reviser", -- Go (整理 import)
				"clang-format", -- C/C++
				"prettier", -- Web (HTML, CSS, JSON, Markdown)
				"shfmt", -- Shell
			},
		})

		-- 2. 配置格式化规则
		conform.setup({
			-- 定义每种语言默认使用哪些格式化工具
			formatters_by_ft = {
				lua = { "stylua" },
				-- Go: 先跑 goimports-reviser 整理引用，再跑 gofumpt 格式化代码
				go = { "goimports-reviser", "gofumpt" },
				-- C++: 使用 clang-format
				cpp = { "clang-format" },
				c = { "clang-format" },
				-- Web / Config
				javascript = { "prettier" },
				typescript = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				bash = { "shfmt" },
			},

			-- 3. 保存自动格式化 (Format on Save)
			format_on_save = {
				-- 只有当没有 LSP 格式化时，才回退到 LSP (lsp_fallback = true)
				-- 比如你没装 clang-format，它就会尝试用 clangd 来格式化
				lsp_fallback = true,
				async = false, -- 同步格式化（保证保存完文件一定是格式化好的）
				timeout_ms = 500, -- 超时时间，大文件可以调大一点
			},
		})

		-- 4. 手动格式化快捷键 (可选)
		vim.keymap.set({ "n", "v" }, "<leader>hf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range" })
	end,
}

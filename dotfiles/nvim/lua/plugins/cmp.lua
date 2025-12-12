return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",

		-- [新增 1] 图标美化插件
		"onsails/lspkind.nvim",

		-- [新增 2] Git 补全插件
		"petertriho/cmp-git",

		"saadparwaiz1/cmp_luasnip",
		{
			"saadparwaiz1/cmp_luasnip",
			dependencies = {
				"L3MON4D3/LuaSnip",
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
			},
		},
	},
	config = function()
		-- 1. 加载代码片段库
		require("luasnip.loaders.from_vscode").lazy_load()
		local luasnip = require("luasnip")
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		-- 2. 初始化 Git 补全 (必须在 cmp.setup 之前)
		require("cmp_git").setup()

		cmp.setup({
			-- [配置 1] 美化图标
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text", -- 同时显示图标和文字
					maxwidth = 50, -- 限制最大宽度
					ellipsis_char = "...", -- 超长截断
					show_labelDetails = true, -- 显示详细信息(比如 import 路径)

					-- 自定义图标颜色等高级配置(可选)
					before = function(entry, vim_item)
						return vim_item
					end,
				}),
			},

			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			-- [配置 2] 核心按键映射 (去除了 Super Tab)
			mapping = cmp.mapping.preset.insert({
				-- 下一个/上一个候选词 (推荐使用 Ctrl+n/p，非常顺手)
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- 滚动文档窗口 (比如查看很长的函数说明)
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- 强制触发补全 (有时候它没自动弹出来，按这个)
				["<C-Space>"] = cmp.mapping.complete(),

				-- 确认选择
				["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
				-- [关键] Tab 键逻辑：仅用于代码片段跳转
				-- 比如你选了 for 循环，填完 i 之后按 Tab 自动跳到 range
				["<Tab>"] = cmp.mapping(function(fallback)
					if luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback() -- 如果不是 snippet，就执行默认 Tab (缩进)
					end
				end, { "i", "s" }),

				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),

			-- 默认补全源
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP
				{ name = "luasnip" }, -- 代码片段
				{ name = "path" }, -- 路径
				{ name = "buffer" }, -- 当前文件缓冲
			}),

			experimental = {
				ghost_text = true, -- 幽灵文本预览
			},
		})

		-- [配置 3] 针对 Git Commit 的特殊配置
		-- 只有在 gitcommit 文件类型下才启用 git 源
		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "git" }, -- 启用 git 补全
			}, {
				{ name = "buffer" },
			}),
		})

		-- 命令行搜索模式 (/ 或 ?)
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- 命令行命令模式 (:)
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}

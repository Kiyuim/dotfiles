local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("lazy").setup({
		-- [1] Flash: 快速跳转
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			vscode = true,
			opts = {},
			keys = {
				{
					"s",
					mode = { "n", "x", "o" },
					function()
						require("flash").jump()
					end,
					desc = "Flash",
				},
				{
					"S",
					mode = { "n", "o", "x" },
					function()
						require("flash").treesitter()
					end,
					desc = "Flash Treesitter",
				},
				{
					"r",
					mode = "o",
					function()
						require("flash").remote()
					end,
					desc = "Remote Flash",
				},
				{
					"R",
					mode = { "o", "x" },
					function()
						require("flash").treesitter_search()
					end,
					desc = "Flash Treesitter Search",
				},
				{
					"<c-s>",
					mode = { "c" },
					function()
						require("flash").toggle()
					end,
					desc = "Toggle Flash Search",
				},
			},
		},

		-- [2] Accelerated-jk: 加速移动
		{
			"rhysd/accelerated-jk",
			vscode = true,
			keys = {
				{ "j", "<Plug>(accelerated_jk_gj)" },
				{ "k", "<Plug>(accelerated_jk_gk)" },
			},
		},

		-- [3] Mini.ai: 增强文本对象
		{
			"echasnovski/mini.ai",
			event = "VeryLazy",
			vscode = true,
			config = true,
		},

		-- [4] Mini.comment: 快速注释
		{
			"echasnovski/mini.comment",
			event = "VeryLazy",
			vscode = true,
			config = true,
		},

		-- [5] Nvim-surround
		{
			"kylechui/nvim-surround",
			event = "VeryLazy",
			vscode = true,
			config = function()
				require("nvim-surround").setup({})
			end,
		},
	}),
})

-- 3. VS Code 功能映射 (把 Vim 键位映射到 VS Code 的命令)
local vscode = require("vscode")
local map = vim.keymap.set
local opt = vim.opt

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- 搜索相关 (这影响 n/N 的跳转逻辑，VS Code 需要)
opt.ignorecase = true
opt.smartcase = true

-- 剪贴板同步
opt.clipboard = "unnamedplus"
opt.timeoutlen = 500

map("v", "J", ":m '>+1<CR>gv=gv")
map("i", "<A-j>", " <Esc>:m .+1<CR>==gi")
map("n", "<A-j>", "<cmd>m .+1<CR>==")
map("v", "K", ":m '<-2<CR>gv=gv")
map("i", "<A-k>", " <Esc>:m .-2<CR>==gi")
map("n", "<A-k>", "<cmd>m .-2<CR>==")

map({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>")
map({ "v", "n" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "i", "x", "n", "s" }, "<C-s>", function()
	vscode.call("workbench.action.files.save")
end)

-- 🔄 [需要翻译的部分] UI 操作，必须调用 VSCode API
-- -------------------------------------------------------

-- 1. Window Resizing (调整 VSCode 分栏大小)
map("n", "<A-Up>", function()
	vscode.call("workbench.action.increaseViewHeight")
end)
map("n", "<A-Down>", function()
	vscode.call("workbench.action.decreaseViewHeight")
end)
map("n", "<A-Left>", function()
	vscode.call("workbench.action.decreaseViewWidth")
end)
map("n", "<A-Right>", function()
	vscode.call("workbench.action.increaseViewWidth")
end)

-- -- 3. Buffer Management (对应 VSCode 的标签页/编辑器)
-- map("n", "<leader>bp", function() vscode.call('workbench.action.previousEditor') end)
-- map("n", "<leader>bn", function() vscode.call('workbench.action.nextEditor') end)
-- map("n", "[b", function() vscode.call('workbench.action.previousEditor') end)
-- map("n", "]b", function() vscode.call('workbench.action.nextEditor') end)
-- map("n", "<leader>bc", function() vscode.call('workbench.action.closeActiveEditor') end)
-- -- VSCode 没有 "List All Buffers" 的概念，对应的是 "Show All Editors"
-- map("n", "<leader>bl", function() vscode.call('workbench.action.showAllEditors') end)

-- 4. Window Management (对应 VSCode 的分屏)
map("n", "<leader>ww", function()
	vscode.call("workbench.action.focusNextGroup")
end)
map("n", "<leader>wd", function()
	vscode.call("workbench.action.closeEditorsInGroup")
end)
map("n", "<leader>wb", function()
	vscode.call("workbench.action.splitEditorDown")
end)
map("n", "<leader>wr", function()
	vscode.call("workbench.action.splitEditorRight")
end)

-- <Leader>f 格式化 -> 调用 VS Code 格式化
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	vscode.call("editor.action.formatDocument")
end)
-- <Leader>e 文件树 -> 显隐侧边栏
vim.keymap.set("n", "<leader>e", function()
	vscode.call("workbench.action.toggleSidebarVisibility")
end)
-- <Leader>rn 重命名 -> F2
vim.keymap.set("n", "<leader>rn", function()
	vscode.call("editor.action.rename")
end)
-- <Leader>ca 代码操作 -> 快速修复
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
	vscode.call("editor.action.quickFix")
end)

vim.keymap.set("n", "<F5>", function()
	vscode.call("workbench.action.debug.continue")
end)
vim.keymap.set("n", "<F10>", function()
	vscode.call("workbench.action.debug.stepOver")
end)
vim.keymap.set("n", "<F11>", function()
	vscode.call("workbench.action.debug.stepInto")
end)
vim.keymap.set("n", "<F12>", function()
	vscode.call("workbench.action.debug.stepOut")
end)

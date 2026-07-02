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
				{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
				{ "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
				{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
				{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Flash TS Search" },
				{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
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

-- ============================================
-- VSCode 专属按键映射
-- ============================================
local vscode = require("vscode")
local map = vim.keymap.set
local opt = vim.opt

vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

opt.ignorecase = true
opt.smartcase = true
opt.clipboard = "unnamedplus"
opt.timeoutlen = 500

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv")
map("i", "<A-j>", " <Esc>:m .+1<CR>==gi")
map("n", "<A-j>", "<cmd>m .+1<CR>==")
map("v", "K", ":m '<-2<CR>gv=gv")
map("i", "<A-k>", " <Esc>:m .-2<CR>==gi")
map("n", "<A-k>", "<cmd>m .-2<CR>==")

-- Clear search + copy
map({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>")
map({ "v", "n" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "i", "x", "n", "s" }, "<C-s>", function()
	vscode.call("workbench.action.files.save")
end)

-- Window Resizing
map("n", "<A-Up>", function() vscode.call("workbench.action.increaseViewHeight") end)
map("n", "<A-Down>", function() vscode.call("workbench.action.decreaseViewHeight") end)
map("n", "<A-Left>", function() vscode.call("workbench.action.decreaseViewWidth") end)
map("n", "<A-Right>", function() vscode.call("workbench.action.increaseViewWidth") end)

-- Window/Split Management
map("n", "<leader>ww", function() vscode.call("workbench.action.focusNextGroup") end)
map("n", "<leader>wd", function() vscode.call("workbench.action.closeEditorsInGroup") end)
map("n", "<leader>wb", function() vscode.call("workbench.action.splitEditorDown") end)
map("n", "<leader>wr", function() vscode.call("workbench.action.splitEditorRight") end)

-- Buffer prev/next
map("n", "[b", function() vscode.call("workbench.action.previousEditor") end, { desc = "Prev Editor" })
map("n", "]b", function() vscode.call("workbench.action.nextEditor") end, { desc = "Next Editor" })
map("n", "<leader>bc", function() vscode.call("workbench.action.closeActiveEditor") end, { desc = "Close Editor" })

-- LSP / UI actions via VSCode
map({ "n", "v" }, "<leader>f", function() vscode.call("editor.action.formatDocument") end, { desc = "Format" })
map("n", "<leader>e", function() vscode.call("workbench.action.toggleSidebarVisibility") end, { desc = "Toggle sidebar" })
map("n", "<leader>rn", function() vscode.call("editor.action.rename") end, { desc = "Rename" })
map({ "n", "v" }, "<leader>ca", function() vscode.call("editor.action.quickFix") end, { desc = "Quick fix" })

-- Debug keys
map("n", "<F5>", function() vscode.call("workbench.action.debug.continue") end)
map("n", "<F10>", function() vscode.call("workbench.action.debug.stepOver") end)
map("n", "<F11>", function() vscode.call("workbench.action.debug.stepInto") end)
map("n", "<F12>", function() vscode.call("workbench.action.debug.stepOut") end)

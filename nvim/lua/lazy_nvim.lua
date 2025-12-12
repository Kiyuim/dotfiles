local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
local opts = {
	install = {
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "tokyonight-storm" },
	},
	change_detection = {
		enabled = true, -- 依然保持自动重载功能（检测到文件变化自动刷新）
		notify = false, -- 【设置为 false】彻底关闭 "Config Change Detected" 这个特定弹窗
	},
}
require("lazy").setup("plugins", opts)

vim.loader.enable()

if vim.g.vscode then
	require("config.vscode")
else
	require("config.options") -- 这里面可能会把 leader 改回 ;，但只在普通模式生效
	require("config.keymaps")
	require("config.neovide")
	require("lazy_nvim")
end

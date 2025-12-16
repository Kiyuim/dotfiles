if vim.g.neovide then
	vim.o.guifont = "Monaco:h14"
	vim.o.linespace = 0

	vim.g.neovide_opacity = 0.85
	vim.g.neovide_window_blurred = true
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	vim.g.neovide_remember_window_size = true
	vim.g.neovide_input_use_logo = true
	vim.g.neovide_input_macos_option_key_is_meta = true
	vim.g.neovide_touch_deadzone = 6.0

	vim.g.neovide_cursor_vfx_mode = "railgun"
	vim.g.neovide_cursor_vfx_opacity = 200.0
	vim.g.neovide_cursor_vfx_particle_lifetime = 1.2
	vim.g.neovide_cursor_vfx_particle_density = 7.0
	vim.g.neovide_cursor_vfx_particle_speed = 10.0
	vim.g.neovide_cursor_vfx_particle_phase = 1.5
	vim.g.neovide_cursor_vfx_particle_curl = 1.0

	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_refresh_rate_idle = 5

	vim.keymap.set("n", "<D-s>", ":w<CR>")
	vim.keymap.set("v", "<D-c>", '"+y')
	vim.keymap.set("n", "<D-v>", '"+p')
	vim.keymap.set("i", "<D-v>", "<C-r>+")
	vim.keymap.set("c", "<D-v>", "<C-r>+")
	vim.keymap.set("t", "<D-v>", '<C-\\><C-n>"+pa')
end

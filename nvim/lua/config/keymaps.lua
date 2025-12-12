local map = vim.keymap.set

-- 1. Window Resizing
-- ===========================================
map("n", "<A-Up>", "<cmd>resize +2<CR>")
map("n", "<A-Down>", "<cmd>resize -2<CR>")
map("n", "<A-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<A-Right>", "<cmd>vertical resize +2<CR>")

-- ===========================================
-- 2. Move Lines 
-- ===========================================
map("v", "J", ":m '>+1<CR>gv=gv")
map("i", "<A-j>", " <Esc>:m .+1<CR>==gi")
map("n", "<A-j>", "<cmd>m .+1<CR>==")
map("v", "K", ":m '<-2<CR>gv=gv")
map("i", "<A-k>", " <Esc>:m .-2<CR>==gi")
map("n", "<A-k>", "<cmd>m .-2<CR>==")

-- ===========================================
-- 3. Buffer Management
-- ===========================================
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Next Buffer" })
map("n", "<leader>bo", "<cmd>enew<CR>", { desc = "Open a New Buffer" })
map("n", "<leader>bl", "<cmd>ls<CR>", { desc = "List All Buffers" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bc", "<cmd>bd<CR>", { desc = "Close Buffer" })

-- ===========================================
-- 4. Window Management (Splits)
-- ===========================================
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>wb", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wr", "<C-W>v", { desc = "Split window right", remap = true })

-- ===========================================
-- 5. Tab Management
-- ===========================================
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- ===========================================
-- 6. General Utilities
-- ===========================================
-- Clear search highlight
map({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>")

-- Save file (Native Vim style)
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<CR><esc>")

-- Copy to system clipboard
map({ "v", "n" }, "<leader>y", "\"+y", { desc = "Copy to system clipboard" })

-- Quit all
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Inspect Highlight Groups
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

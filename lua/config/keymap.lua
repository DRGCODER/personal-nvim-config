vim.keymap.set("n", "<leader>t", vim.cmd.term, { desc = "terminal" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- navigate between buffers
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bx", ":bd<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bc", function()
	local buffers_in_tab = #vim.fn.tabpagebuflist()
	if buffers_in_tab > 1 then
		vim.cmd("bdelete")
	else
		-- If it's the only buffer in tab, close the tab
		vim.cmd("tabclose")
	end
end, { desc = "Close buffer" })

-- indent code while it is still selected
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- center cursor when navigating text using <C-d> & <C-u>
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

-- center cursor when navigating search && remove search hl
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<ESC>", vim.cmd.nohl, { desc = "remove the search highlight" })

-- the how it be paste
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Y to EOL
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })
vim.keymap.set("n", "J", "mzJ`z")

-- ctrl c as escape cuz Im lazy to reach up to the esc key
vim.keymap.set("i", "jj", "<Esc>")

-- Splitting & Resizing
vim.keymap.set("n", "<leader>ss", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-l>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-h>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

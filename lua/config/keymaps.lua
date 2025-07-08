vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- netRW binding
vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })

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

-- move selected text up and down in V mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

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

-- remember yanked
vim.keymap.set("v", "p", '"_dp')

-- Copies or Yank to system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- leader d delete wont remember as yanked/clipboard when delete pasting
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- ctrl c as escape cuz Im lazy to reach up to the esc key
vim.keymap.set("i", "jj", "<Esc>")

-- Splitting & Resizing
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
vim.keymap.set("n", "<C-l>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-h>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move lines up/down
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- open config files
vim.keymap.set("n", "<leader>fc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- conform formatter info
vim.keymap.set("n", "<leader>cn", "<cmd>ConformInfo<cr>", { desc = "Conform formatter info" })

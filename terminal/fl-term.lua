-- terminal script
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
local M = {}

function M.open_split_term()
    vim.cmd("split | terminal")
    vim.cmd("startinsert")
end

function M.open_vsplit_term()
    vim.cmd("vsplit | terminal")
    vim.cmd("startinsert")
end

function M.toggle_float_term()
    local bufnr = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.fn.termopen(os.getenv("SHELL"))
    vim.cmd("startinsert")
end

function M.setup_keymaps()
    vim.keymap.set("n", "<leader>ts", M.open_split_term, { desc = "Terminal split" })
    vim.keymap.set("n", "<leader>tv", M.open_vsplit_term, { desc = "Terminal vsplit" })
    vim.keymap.set("n", "<leader>tf", M.toggle_float_term, { desc = "Terminal float" })
end

return M


-- Remap leaving 'terminal mode' to double tap esc
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
--
-- local state = {
--     floating = {
--         buf = -1,
--         win = -1,
--     }
-- }
--
-- local function open_floating_terminal(opts)
--     opts = opts or {}
--     local width = opts.width or math.floor(vim.o.columns * 0.8)
--     local height = opts.height or math.floor(vim.o.lines * 0.8)
--
--     local row = math.floor((vim.o.lines - height) / 2)
--     local col = math.floor((vim.o.columns - width) / 2)
--
--     local buf = nil
--     if vim.api.nvim_buf_is_valid(opts.buf) then
--         buf = opts.buf
--     else
--         buf = vim.api.nvim_create_buf(false, true)
--     end
--     if not buf then
--         error("Failed to create buffer")
--     end
--
--     local win = vim.api.nvim_open_win(buf, true, {
--         relative = 'editor',
--         width = width,
--         height = height,
--         row = row,
--         col = col,
--         style = 'minimal',
--         border = 'rounded',
--     })
--
--     return { buf = buf, win = win }
-- end
--
-- local toggle_terminal = function()
--     if not vim.api.nvim_win_is_valid(state.floating.win) then
--         state.floating = open_floating_terminal({ buf = state.floating.buf });
--         if vim.bo[state.floating.buf].buftype ~= "terminal" then
--             vim.cmd.terminal()
--             vim.cmd("startinsert!")
--         end
--     else
--         vim.api.nvim_win_hide(state.floating.win)
--     end
-- end
--
-- vim.api.nvim_create_user_command("Flterm", toggle_terminal, {})
-- vim.api.nvim_set_keymap('n', '<leader>ft', [[:Flterm<CR>]], { noremap = true, silent = true })

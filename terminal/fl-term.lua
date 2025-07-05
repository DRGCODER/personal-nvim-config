-- terminal script
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
-- local M = {}
--
-- -- Store state
-- local float_term = {
--     bufnr = nil,
--     win_id = nil,
-- }
--
-- function M.toggle_float_term()
--     -- If window is open and valid, close it
--     if float_term.win_id and vim.api.nvim_win_is_valid(float_term.win_id) then
--         vim.api.nvim_win_close(float_term.win_id, true)
--         float_term.win_id = nil
--         float_term.bufnr = nil
--         return
--     end
--
--     -- Otherwise, open a new floating terminal
--     float_term.bufnr = vim.api.nvim_create_buf(false, true)
--     local width = math.floor(vim.o.columns * 0.8)
--     local height = math.floor(vim.o.lines * 0.8)
--     local row = math.floor((vim.o.lines - height) / 2)
--     local col = math.floor((vim.o.columns - width) / 2)
--
--     float_term.win_id = vim.api.nvim_open_win(float_term.bufnr, true, {
--         relative = "editor",
--         width = width,
--         height = height,
--         row = row,
--         col = col,
--         style = "minimal",
--         border = "rounded",
--     })
--
--     vim.fn.termopen(os.getenv("SHELL"))
--     vim.cmd("startinsert")
-- end
--
-- function M.open_split_term()
--     vim.cmd("split | terminal")
--     vim.cmd("startinsert")
-- end
--
-- function M.open_vsplit_term()
--     vim.cmd("vsplit | terminal")
--     vim.cmd("startinsert")
-- end
--
-- function M.setup_keymaps()
--     vim.keymap.set("n", "<leader>ts", M.open_split_term, { desc = "Terminal split" })
--     vim.keymap.set("n", "<leader>tv", M.open_vsplit_term, { desc = "Terminal vsplit" })
--     vim.keymap.set("n", "<leader>tf", M.toggle_float_term, { desc = "Terminal float (toggle)" })
-- end
--
-- return M
--


-- Remap leaving 'terminal mode' to double tap esc
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
local M = {}

-- Module-local state
local state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

-- Helper to open a floating terminal window
local function open_floating_terminal(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local buf
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(true, false) -- listed, not scratch
    end

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
    })

    return { buf = buf, win = win }
end

-- Public toggle function
function M.toggle_terminal()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = open_floating_terminal({ buf = state.floating.buf })
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
            vim.cmd("startinsert!")
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

-- Setup function for command and keymaps
function M.setup()
    vim.api.nvim_create_user_command("Flterm", M.toggle_terminal, {})
    vim.keymap.set('n', '<leader>ft', M.toggle_terminal,
        { desc = "Toggle floating terminal", noremap = true, silent = true })
end

return M

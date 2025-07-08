require("config.auto-commands")
require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.tabs")
require("config.statusline")

-- theme & transparency
-- vim.cmd.colorscheme("default") -- default theme
-- vim.cmd.colorscheme("elflord") -- noth that cool but will do red on black
-- vim.cmd.colorscheme("habamax")     -- this preety chil theme
-- vim.cmd.colorscheme("slate") -- this preety chil theme too
-- vim.cmd.colorscheme("wildcharm") -- this is one of the canidate
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- floating terminal setup
-- vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")
--
-- -- Store state
-- local state = {
--     floating = {
--         buf = -1,
--         win = -1,
--     }
-- }
-- local function create_float_term(opts)
--     opts = opts or {}
--     local width = opts.width or math.floor(vim.o.columns * 0.8)
--     local height = opts.height or math.floor(vim.o.lines * 0.8)
--     local row = math.floor((vim.o.lines - height) / 2)
--     local col = math.floor((vim.o.columns - width) / 2)
--     local buf = nil
--     if vim.api.nvim_buf_is_valid(opts.buf) then
--         buf = opts.buf
--     else
--         buf = vim.api.nvim_create_buf(true, false) -- listed, not scratch
--     end
--     local win = vim.api.nvim_open_win(buf, true, {
--         relative = 'editor',
--         width = width,
--         height = height,
--         row = row,
--         col = col,
--         style = 'minimal',
--         border = 'rounded',
--     })
--     return { buf = buf, win = win }
-- end
-- local toggle_terminal = function()
--     if not vim.api.nvim_win_is_valid(state.floating.win) then
--         state.floating = create_float_term { buf = state.floating.buf }
--         if vim.bo[state.floating.buf].buftype ~= "terminal" then
--             vim.cmd.terminal()
--         end
--     else
--         vim.api.nvim_win_hide(state.floating.win)
--     end
-- end
-- local function open_split_term()
--     vim.cmd("split | terminal")
--     vim.cmd("startinsert")
-- end
-- local function open_vsplit_term()
--     vim.cmd("vsplit | terminal")
--     vim.cmd("startinsert")
-- end
-- vim.api.nvim_create_user_command("Flterm", toggle_terminal, {})
-- vim.api.nvim_create_user_command("SFloaterminal", open_split_term, {})
-- vim.api.nvim_create_user_command("VFloaterminal", open_vsplit_term, {})
-- vim.api.nvim_create_autocmd("TermOpen", {
--     group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
--     callback = function()
--         vim.opt.number = false
--         vim.opt.relativenumber = false
--     end,
-- })

-- terminal
local terminal_state = {
    buf = nil,
    win = nil,
    is_open = false,
}

local function FloatingTerminal()
    -- If terminal is already open, close it (toggle behavior)
    if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
        return
    end

    -- Create buffer if it doesn't exist or is invalid
    if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
        terminal_state.buf = vim.api.nvim_create_buf(false, true)
        -- Set buffer options for better terminal experience
        vim.api.nvim_buf_set_option(terminal_state.buf, "bufhidden", "hide")
    end

    -- Calculate window dimensions
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)
    -- Create the floating window
    terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    -- Set transparency for the floating window
    vim.api.nvim_win_set_option(terminal_state.win, "winblend", 0)

    -- Set transparent background for the window
    vim.api.nvim_win_set_option(
        terminal_state.win,
        "winhighlight",
        "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
    )

    -- Define highlight groups for transparency
    vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

    -- Start terminal if not already running
    local has_terminal = false
    local lines = vim.api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
    for _, line in ipairs(lines) do
        if line ~= "" then
            has_terminal = true
            break
        end
    end

    if not has_terminal then
        vim.fn.termopen(os.getenv("SHELL"))
    end

    terminal_state.is_open = true
    vim.cmd("startinsert")

    -- Set up auto-close on buffer leave
    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = terminal_state.buf,
        callback = function()
            if terminal_state.is_open and vim.api.nvim_win_is_valid(terminal_state.win) then
                vim.api.nvim_win_close(terminal_state.win, false)
                terminal_state.is_open = false
            end
        end,
        once = true,
    })
end

-- Key mappings
vim.keymap.set(
    "n",
    "<leader>ft",
    FloatingTerminal,
    { noremap = true, silent = true, desc = "Toggle floating terminal" }
)
vim.keymap.set("t", "<Esc>", function()
    if terminal_state.is_open then
        vim.api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
    end
end, { noremap = true, silent = true, desc = "Close floating terminal from terminal mode" })

-- neovide config
if vim.g.neovide then
    vim.opt.guifont = "Monaspace Argon:h20:b:i"
    vim.opt.linespace = 20
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_fullscreen = true
    --   -- g:neovide_opacity should be 0 if you want to unify transparency of content and title bar.
    vim.g.neovide_opacity = 0.0
    vim.g.neovide_cursor_antialiasing = true
    vim.g.transparency = 0.80
    vim.g.neovide_background_color = "#000000"
    vim.g.neovide_padding_top = 3
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0
    vim.g.neovide_title_text_color = "black"
    vim.g.neovide_window_blurred = true
    vim.g.neovide_refresh_rate = 120
end

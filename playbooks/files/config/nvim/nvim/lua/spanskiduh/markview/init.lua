local M = {}
local display_mode_var = "spanskiduh_markview_display"

local function is_markdown_buffer(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    if vim.bo[bufnr].buftype ~= "" then return end
    return vim.bo[bufnr].filetype == "markdown"
end

local function get_display_mode(bufnr)
    local mode = vim.b[bufnr][display_mode_var]
    if mode == "inline" then return "inline" end
    return "split"
end

local function set_display_mode(bufnr, mode)
    vim.b[bufnr][display_mode_var] = mode
end

local function get_split_source()
    local ok, state = pcall(require, "markview.state")
    if not ok then return nil end

    return state.get_splitview_source()
end

local function get_buffer_state(bufnr)
    local ok, state = pcall(require, "markview.state")
    if not ok then return nil end

    return state.get_buffer_state(bufnr, false)
end

local function open_markview_split(bufnr)
    if not is_markdown_buffer(bufnr) then return end
    if get_split_source() == bufnr then return end

    vim.api.nvim_buf_call(bufnr, function() pcall(vim.cmd, "Markview splitOpen") end)
end

local function close_markview_split(bufnr)
    if get_split_source() ~= bufnr then return end

    pcall(vim.cmd, "Markview splitClose")
end

function M.toggle_split(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not is_markdown_buffer(bufnr) then return end

    set_display_mode(bufnr, "split")

    local buf_state = get_buffer_state(bufnr)
    if buf_state and buf_state.enable then
        vim.api.nvim_buf_call(bufnr, function() pcall(vim.cmd, "Markview disable") end)
    end

    if get_split_source() == bufnr then
        close_markview_split(bufnr)
        return
    end

    open_markview_split(bufnr)
end

function M.toggle_inline(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not is_markdown_buffer(bufnr) then return end

    local split_source = get_split_source()
    local buf_state = get_buffer_state(bufnr)
    local inline_enabled = buf_state and buf_state.enable == true and split_source ~= bufnr

    if split_source and split_source ~= bufnr then pcall(vim.cmd, "Markview splitClose") end

    if split_source == bufnr then
        close_markview_split(bufnr)
        set_display_mode(bufnr, "inline")
        vim.api.nvim_buf_call(bufnr, function() pcall(vim.cmd, "Markview enable") end)
        return
    end

    if inline_enabled then
        vim.api.nvim_buf_call(bufnr, function() pcall(vim.cmd, "Markview disable") end)
        set_display_mode(bufnr, "split")
        open_markview_split(bufnr)
        return
    end

    set_display_mode(bufnr, "inline")
    vim.api.nvim_buf_call(bufnr, function() pcall(vim.cmd, "Markview enable") end)
end

function M.setup()
    local ok, markview = pcall(require, "markview")
    if not ok then return end

    markview.setup({
        preview = {
            enable = false,
            filetypes = {"markdown"},
            icon_provider = "internal",
            map_gx = false,
            splitview_winopts = {split = "right"}
        }
    })

    local group = vim.api.nvim_create_augroup("SpanskiduhMarkview", {clear = true})
    vim.api.nvim_create_autocmd({"BufWinEnter", "FileType"}, {
        group = group,
        callback = function(args)
            if get_display_mode(args.buf) ~= "split" then return end

            vim.schedule(function() open_markview_split(args.buf) end)
        end
    })

    vim.api.nvim_create_autocmd({"BufDelete", "BufWinLeave"}, {
        group = group,
        callback = function(args) close_markview_split(args.buf) end
    })

    local current_buf = vim.api.nvim_get_current_buf()
    if is_markdown_buffer(current_buf) then
        vim.schedule(function() open_markview_split(current_buf) end)
    end
end

return M

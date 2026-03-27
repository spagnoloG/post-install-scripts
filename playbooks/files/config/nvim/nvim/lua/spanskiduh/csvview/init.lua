local M = {}

local function enable_csvview(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then return end
    if vim.bo[bufnr].buftype ~= "" then return end

    vim.api.nvim_buf_call(bufnr, function() pcall(vim.cmd, "CsvViewEnable") end)
end

function M.setup()
    local ok, csvview = pcall(require, "csvview")
    if not ok then return end

    csvview.setup({
        parser = {comments = {"#", "//"}},
        keymaps = {
            textobject_field_inner = {"if", mode = {"o", "x"}},
            textobject_field_outer = {"af", mode = {"o", "x"}},
            jump_next_field_end = {"<Tab>", mode = {"n", "v"}},
            jump_prev_field_end = {"<S-Tab>", mode = {"n", "v"}},
            jump_next_row = {"<Enter>", mode = {"n", "v"}},
            jump_prev_row = {"<S-Enter>", mode = {"n", "v"}}
        }
    })

    local group = vim.api.nvim_create_augroup("SpanskiduhCsvView", {clear = true})
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = {"csv", "tsv"},
        callback = function(args)
            vim.schedule(function() enable_csvview(args.buf) end)
        end
    })

    local current_buf = vim.api.nvim_get_current_buf()
    local current_ft = vim.bo[current_buf].filetype
    if current_ft == "csv" or current_ft == "tsv" then
        vim.schedule(function() enable_csvview(current_buf) end)
    end
end

return M

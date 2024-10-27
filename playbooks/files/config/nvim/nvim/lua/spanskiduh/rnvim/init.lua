-- Ensure R.nvim is loaded
local ok, r = pcall(require, "r")
if not ok then return end

-- Key mappings for R.nvim
vim.keymap.set('n', '<leader>rl', "<Plug>RDSendLine", {desc = "Send line to R"})
vim.keymap.set('v', '<leader>rs', "<Plug>RSendSelection",
               {desc = "Send selection to R"})

-- R.nvim setup
r.setup({
    auto_start = "on startup",
    hook = {
        on_filetype = function()
            vim.api.nvim_buf_set_keymap(0, "n", "<Enter>", "<Plug>RDSendLine",
                                        {})
            vim.api.nvim_buf_set_keymap(0, "v", "<Enter>",
                                        "<Plug>RSendSelection", {})
        end
    },
    R_args = {"--quiet", "--no-save"},
    min_editor_width = 72,
    rconsole_width = 78,
    objbr_mappings = {
        c = 'class',
        ['<localleader>gg'] = 'head({object}, n = 15)',
        v = function() require('r.browser').toggle_view() end
    },
    disable_cmds = {"RClearConsole", "RCustomStart", "RSPlot", "RSaveClose"}
})

-- Auto-start configuration based on environment variable
if vim.env.R_AUTO_START == "true" then
    r.setup({auto_start = "on startup", objbr_auto_start = true})
end


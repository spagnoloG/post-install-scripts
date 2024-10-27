-- Ensure R.nvim is loaded
local ok, r = pcall(require, "r")
local ok_wk, wk = pcall(require, "which-key")
if not (ok and ok_wk) then return end

-- R.nvim setup
r.setup({
    auto_start = "on startup",
    objbr_auto_start = true,
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

-- Conditional WhichKey mappings for .R files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "r",
    callback = function()
        wk.add({
            {
                "<leader>rl",
                "<Plug>RDSendLine",
                desc = "Send line to R",
                mode = "n",
                buffer = true
            }, {
                "<leader>rs",
                "<Plug>RSendSelection",
                desc = "Send selection to R",
                mode = "v",
                buffer = true
            },
            {
                "<leader>rh",
                "<Plug>RHelp",
                desc = "R Help",
                mode = "n",
                buffer = true
            }, {
                "<leader>ro",
                "<Plug>RObjBrowser",
                desc = "R Object Browser",
                mode = "n",
                buffer = true
            }
        })
    end
})

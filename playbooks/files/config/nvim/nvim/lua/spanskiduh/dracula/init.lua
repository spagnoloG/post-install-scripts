local M = {}

function M.load()
    local ok, dracula = pcall(require, "dracula")
    if not ok then
        vim.cmd.colorscheme("default")
        vim.notify("Failed to load dracula colorscheme, using default",
                   vim.log.levels.WARN)
        return
    end

    local colors = dracula.colors()

    dracula.setup({
        colors = {},
        show_end_of_buffer = false,
        transparent_bg = false,
        lualine_bg_color = nil,
        italic_comment = true,
        overrides = {
            CursorLineNr = {fg = colors.yellow, bold = true},
            WinSeparator = {fg = colors.selection},

            NormalFloat = {bg = colors.menu},
            FloatBorder = {fg = colors.comment, bg = colors.menu},
            FloatTitle = {fg = colors.cyan, bg = colors.menu, bold = true},

            Pmenu = {fg = colors.white, bg = colors.menu},
            PmenuSel = {fg = "NONE", bg = colors.selection, bold = true},
            PmenuSbar = {bg = colors.bg},
            PmenuThumb = {bg = colors.selection},

            Search = {fg = colors.bg, bg = colors.purple, bold = true},
            IncSearch = {fg = colors.bg, bg = colors.orange, bold = true},
            CurSearch = {fg = colors.bg, bg = colors.orange, bold = true},

            TelescopePromptNormal = {bg = colors.menu},
            TelescopePromptBorder = {fg = colors.menu, bg = colors.menu},
            TelescopeResultsNormal = {bg = colors.bg},
            TelescopeResultsBorder = {fg = colors.bg, bg = colors.bg},
            TelescopePreviewNormal = {bg = colors.bg},
            TelescopePreviewBorder = {fg = colors.bg, bg = colors.bg},
            TelescopePromptTitle = {
                fg = colors.bg,
                bg = colors.cyan,
                bold = true
            },
            TelescopeResultsTitle = {
                fg = colors.bg,
                bg = colors.green,
                bold = true
            },
            TelescopePreviewTitle = {
                fg = colors.bg,
                bg = colors.purple,
                bold = true
            },

            NeoTreeFloatBorder = {fg = colors.comment, bg = colors.menu},
            NeoTreeFloatTitle = {fg = colors.cyan, bg = colors.menu, bold = true},
            NeoTreeTitleBar = {fg = colors.bg, bg = colors.cyan, bold = true}
        }
    })

    local loaded = pcall(vim.cmd.colorscheme, "dracula")
    if not loaded then
        vim.cmd.colorscheme("default")
        vim.notify("Failed to load dracula, using default",
                   vim.log.levels.WARN)
    end
end

return M

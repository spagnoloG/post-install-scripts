local M = {}

local function diagnostic_tint(color, background)
    local blend = require("kanagawa.lib.color")
    return {fg = color, bg = blend(color):blend(background, 0.95):to_hex()}
end

function M.load()
    local theme_variant = vim.g.spanskiduh_kanagawa_theme or "dragon"
    local ok, kanagawa = pcall(require, "kanagawa")
    if not ok then
        vim.cmd.colorscheme("default")
        vim.notify("Failed to load kanagawa colorscheme, using default",
                   vim.log.levels.WARN)
        return
    end

    kanagawa.setup({
        compile = false,
        undercurl = true,
        commentStyle = {italic = true},
        functionStyle = {},
        keywordStyle = {italic = false},
        statementStyle = {bold = true},
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        theme = theme_variant,
        background = {dark = theme_variant, light = "lotus"},
        colors = {
            theme = {
                all = {
                    ui = {
                        bg_gutter = "none"
                    }
                }
            }
        },
        overrides = function(colors)
            local palette = colors.palette
            local theme = colors.theme

            return {
                CursorLineNr = {fg = palette.autumnYellow, bold = true},
                WinSeparator = {fg = palette.sumiInk4},

                NormalFloat = {bg = theme.ui.bg_p1},
                FloatBorder = {fg = palette.sumiInk4, bg = theme.ui.bg_p1},
                FloatTitle = {
                    fg = palette.crystalBlue,
                    bg = theme.ui.bg_p1,
                    bold = true
                },

                Pmenu = {fg = theme.ui.shade0, bg = theme.ui.bg_p1},
                PmenuSel = {fg = "NONE", bg = theme.ui.bg_p2, bold = true},
                PmenuSbar = {bg = theme.ui.bg_m1},
                PmenuThumb = {bg = theme.ui.bg_p2},

                Search = {
                    fg = palette.sumiInk0,
                    bg = palette.waveBlue2,
                    bold = true
                },
                IncSearch = {
                    fg = palette.sumiInk0,
                    bg = palette.autumnYellow,
                    bold = true
                },
                CurSearch = {
                    fg = palette.sumiInk0,
                    bg = palette.autumnYellow,
                    bold = true
                },

                DiagnosticVirtualTextHint = diagnostic_tint(theme.diag.hint,
                                                            theme.ui.bg),
                DiagnosticVirtualTextInfo = diagnostic_tint(theme.diag.info,
                                                            theme.ui.bg),
                DiagnosticVirtualTextWarn = diagnostic_tint(theme.diag.warning,
                                                            theme.ui.bg),
                DiagnosticVirtualTextError = diagnostic_tint(theme.diag.error,
                                                             theme.ui.bg),

                TelescopePromptNormal = {bg = theme.ui.bg_p1},
                TelescopePromptBorder = {
                    fg = theme.ui.bg_p1,
                    bg = theme.ui.bg_p1
                },
                TelescopeResultsNormal = {bg = theme.ui.bg_dim},
                TelescopeResultsBorder = {
                    fg = theme.ui.bg_dim,
                    bg = theme.ui.bg_dim
                },
                TelescopePreviewNormal = {bg = theme.ui.bg_dim},
                TelescopePreviewBorder = {
                    fg = theme.ui.bg_dim,
                    bg = theme.ui.bg_dim
                },
                TelescopePromptTitle = {
                    fg = palette.sumiInk0,
                    bg = palette.crystalBlue,
                    bold = true
                },
                TelescopeResultsTitle = {
                    fg = palette.sumiInk0,
                    bg = palette.waveAqua2,
                    bold = true
                },
                TelescopePreviewTitle = {
                    fg = palette.sumiInk0,
                    bg = palette.springGreen,
                    bold = true
                },

                NeoTreeFloatBorder = {
                    fg = palette.sumiInk4,
                    bg = theme.ui.bg_p1
                },
                NeoTreeFloatTitle = {
                    fg = palette.crystalBlue,
                    bg = theme.ui.bg_p1,
                    bold = true
                },
                NeoTreeTitleBar = {
                    fg = palette.sumiInk0,
                    bg = palette.crystalBlue,
                    bold = true
                }
            }
        end
    })

    local loaded = pcall(vim.cmd.colorscheme, "kanagawa-" .. theme_variant)
    if not loaded then
        vim.cmd.colorscheme("default")
        vim.notify("Failed to load kanagawa-" .. theme_variant ..
                       ", using default", vim.log.levels.WARN)
    end
end

return M

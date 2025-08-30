local ok, wk = pcall(require, "which-key")
if not ok then return end

wk.setup {
    preset = "modern",
    debug = false, -- Disable debug messages
    plugins = {
        marks = true,
        registers = true,
        spelling = {enabled = true, suggestions = 20},
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true
        }
    },
    defer = function(ctx) return ctx.mode == "V" or ctx.mode == "<C-V>" end,
    replace = {["<space>"] = "SPC", ["<cr>"] = "RET", ["<tab>"] = "TAB"},
    icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
        ellipsis = "…",
        mappings = true,
        rules = false,
        colors = true,
        keys = {
            Up = " ",
            Down = " ",
            Left = " ",
            Right = " ",
            C = "󰘴 ",
            M = "󰘵 ",
            S = "󰘶 ",
            CR = "󰌑 ",
            Esc = "󱊷 ",
            ScrollWheelDown = "󰄼 ",
            ScrollWheelUp = "󰄽 ",
            NL = "󰌑 ",
            BS = "⌫",
            Space = "󱁐 ",
            Tab = "󰌒 "
        }
    },
    keys = {scroll_down = "<c-d>", scroll_up = "<c-u>"},
    win = {border = "rounded", padding = {1, 2}, wo = {winblend = 0}},
    layout = {width = {min = 20}, spacing = 3},
    expand = 1,
    filter = function(mapping) return true end,
    spec = {},
    triggers = {{"<auto>", mode = "nxso"}},
    delay = 200,
    notify = false -- Disable notifications about overlapping keys
}

-- Register core keybindings from remap.lua with emojis
wk.add({
    -- File operations
    {"<leader>pv", vim.cmd.Ex, desc = "📁 File Explorer", mode = "n"},

    -- Clipboard operations
    {"<leader>p", "\"_dP", desc = "📋 Paste without yanking", mode = "x"},
    {"<leader>y", "\"+y", desc = "📋 Yank to clipboard", mode = {"n", "v"}},
    {"<leader>Y", "\"+Y", desc = "📋 Yank line to clipboard", mode = "n"}, {
        "<leader>d",
        "\"_d",
        desc = "🗑️ Delete without yanking",
        mode = {"n", "v"}
    }, -- LSP operations (grouped under 'l')
    {"<leader>l", group = "⚡ lsp", icon = "⚡"}, {
        "<leader>lf",
        function() vim.lsp.buf.format() end,
        desc = "✨ Format document",
        mode = "n"
    }, -- Quickfix navigation (grouped under 'q')
    {"<leader>q", group = "🔧 quickfix", icon = "🔧"},
    {"<leader>qq", ":q<CR>", desc = "🚪 Quit", mode = "n"},
    {
        "<leader>qn",
        "<cmd>cnext<CR>zz",
        desc = "⬇️ Next quickfix",
        mode = "n"
    }, {
        "<leader>qp",
        "<cmd>cprev<CR>zz",
        desc = "⬆️ Previous quickfix",
        mode = "n"
    }, -- Location list navigation  
    {
        "<leader>ln",
        "<cmd>lnext<CR>zz",
        desc = "⬇️ Next location",
        mode = "n"
    }, {
        "<leader>lp",
        "<cmd>lprev<CR>zz",
        desc = "⬆️ Previous location",
        mode = "n"
    }, -- Search/Replace (grouped under 's')
    {"<leader>s", group = "🔍 search", icon = "🔍"}, {
        "<leader>sr",
        ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
        desc = "🔄 Replace word under cursor",
        mode = "n"
    }, -- File operations
    {
        "<leader>x",
        "<cmd>!chmod +x %<CR>",
        desc = "⚙️ Make file executable",
        mode = "n",
        silent = true
    }, -- Window operations
    {"<leader>w", group = "🪟 window", icon = "🪟"},
    {"<leader>wh", ":split<CR>", desc = "↔️ Horizontal split", mode = "n"},
    {"<leader>wv", ":vsplit<CR>", desc = "↕️ Vertical split", mode = "n"},

    -- Tree operations
    {"<leader>n", group = "🌳 neo-tree", icon = "🌳"},
    {
        "<leader>nt",
        ":Neotree toggle<CR>",
        desc = "🔄 Toggle Neotree",
        mode = "n"
    }, -- Undo operations
    {
        "<leader>u",
        vim.cmd.UndotreeToggle,
        desc = "🔙 Toggle Undotree",
        mode = "n"
    }, -- Git operations
    {"<leader>g", group = "🔧 git", icon = "🔧"},
    {"<leader>gs", vim.cmd.Git, desc = "📊 Git status", mode = "n"},
    {"<leader>ga", ":Git add %<CR>", desc = "➕ Add current file", mode = "n"},
    {"<leader>gA", ":Git add .<CR>", desc = "➕ Add all files", mode = "n"},
    {"<leader>gc", ":Git commit<CR>", desc = "💾 Commit", mode = "n"}, {
        "<leader>gC",
        ":Git commit --amend<CR>",
        desc = "🔄 Commit amend",
        mode = "n"
    }, {"<leader>gp", ":Git push<CR>", desc = "⬆️ Push", mode = "n"},
    {"<leader>gP", ":Git pull<CR>", desc = "⬇️ Pull", mode = "n"},
    {"<leader>gf", ":Git fetch<CR>", desc = "📥 Fetch", mode = "n"}, {
        "<leader>gl",
        ":Git log --oneline<CR>",
        desc = "📜 Log (oneline)",
        mode = "n"
    }, {"<leader>gL", ":Git log<CR>", desc = "📜 Log (full)", mode = "n"},
    {"<leader>gb", ":Git blame<CR>", desc = "👤 Blame", mode = "n"},
    {"<leader>gd", ":Gdiffsplit<CR>", desc = "🔀 Diff split", mode = "n"},
    {"<leader>gD", ":Git diff<CR>", desc = "🔍 Diff", mode = "n"},
    {
        "<leader>gh",
        ":diffget //2<CR>",
        desc = "⬅️ Get left diff",
        mode = "n"
    },
    {
        "<leader>gj",
        ":diffget //3<CR>",
        desc = "➡️ Get right diff",
        mode = "n"
    }, {"<leader>gm", ":Git merge<CR>", desc = "🔀 Merge", mode = "n"},
    {"<leader>gr", ":Git rebase<CR>", desc = "🔄 Rebase", mode = "n"},
    {"<leader>gR", ":Git reset<CR>", desc = "↩️ Reset", mode = "n"},
    {"<leader>gt", ":Git stash<CR>", desc = "📦 Stash", mode = "n"},
    {"<leader>gT", ":Git stash pop<CR>", desc = "📦 Stash pop", mode = "n"},
    {"<leader>gw", ":Gwrite<CR>", desc = "💾 Write & stage", mode = "n"},
    {"<leader>gx", ":GDelete<CR>", desc = "🗑️ Delete file", mode = "n"},

    -- VimTeX operations
    {"<leader>t", group = "📄 vimtex", icon = "📄"},
    {"<leader>tc", "<plug>(vimtex-compile)", desc = "🔨 Compile", mode = "n"},
    {
        "<leader>tC",
        "<plug>(vimtex-compile-ss)",
        desc = "🔨 Compile (single shot)",
        mode = "n"
    }, {
        "<leader>tk",
        "<plug>(vimtex-stop)",
        desc = "⏹️ Stop compilation",
        mode = "n"
    }, {
        "<leader>tK",
        "<plug>(vimtex-stop-all)",
        desc = "⏹️ Stop all compilations",
        mode = "n"
    },
    {
        "<leader>te",
        "<plug>(vimtex-errors)",
        desc = "❌ Show errors",
        mode = "n"
    }, {
        "<leader>to",
        "<plug>(vimtex-compile-output)",
        desc = "📋 Show output",
        mode = "n"
    },
    {"<leader>tg", "<plug>(vimtex-status)", desc = "📊 Status", mode = "n"},
    {
        "<leader>tG",
        "<plug>(vimtex-status-all)",
        desc = "📊 Status (all)",
        mode = "n"
    },
    {"<leader>tv", "<plug>(vimtex-view)", desc = "👁️ View PDF", mode = "n"},
    {
        "<leader>tr",
        "<plug>(vimtex-reverse-search)",
        desc = "🔍 Reverse search",
        mode = "n"
    }, {
        "<leader>tl",
        "<plug>(vimtex-compile-selected)",
        desc = "🔨 Compile selection",
        mode = {"n", "x"}
    }, {"<leader>ti", "<plug>(vimtex-info)", desc = "ℹ️ Info", mode = "n"},
    {
        "<leader>tI",
        "<plug>(vimtex-info-full)",
        desc = "ℹ️ Full info",
        mode = "n"
    }, {
        "<leader>tt",
        "<plug>(vimtex-toc-open)",
        desc = "📑 Table of contents",
        mode = "n"
    }, {
        "<leader>tT",
        "<plug>(vimtex-toc-toggle)",
        desc = "📑 Toggle TOC",
        mode = "n"
    }, {"<leader>tq", "<plug>(vimtex-log)", desc = "📜 View log", mode = "n"},
    {
        "<leader>ts",
        "<plug>(vimtex-toggle-main)",
        desc = "🔄 Toggle main file",
        mode = "n"
    }, {
        "<leader>ta",
        "<plug>(vimtex-context-menu)",
        desc = "📋 Context menu",
        mode = "n"
    },
    {"<leader>tx", "<plug>(vimtex-reload)", desc = "🔄 Reload", mode = "n"},
    {
        "<leader>tX",
        "<plug>(vimtex-reload-state)",
        desc = "🔄 Reload state",
        mode = "n"
    }, {
        "<leader>tm",
        "<plug>(vimtex-imaps-list)",
        desc = "🗺️ Insert mode maps",
        mode = "n"
    },
    {"<leader>tw", "<plug>(vimtex-words)", desc = "📝 Word count", mode = "n"},
    {
        "<leader>td",
        "<plug>(vimtex-doc-package)",
        desc = "📚 Package documentation",
        mode = "n"
    }, {
        "<leader>tD",
        "<plug>(vimtex-doc-package-window)",
        desc = "📚 Package doc (window)",
        mode = "n"
    }, -- Claude Code operations (avoiding duplicates)
    {"<leader>c", group = "🤖 claude-code", icon = "🤖"}, {
        "<leader>cc",
        "<cmd>ClaudeCode<CR>",
        desc = "🤖 Toggle Claude Code",
        mode = "n"
    }, {
        "<leader>cC",
        "<cmd>ClaudeCodeContinue<CR>",
        desc = "▶️ Claude Code Continue",
        mode = "n"
    }, {
        "<leader>cV",
        "<cmd>ClaudeCodeVerbose<CR>",
        desc = "🔊 Claude Code Verbose",
        mode = "n"
    }, {
        "<leader>cr",
        "<cmd>ClaudeCodeResume<CR>",
        desc = "⏯️ Claude Code Resume",
        mode = "n"
    }
})

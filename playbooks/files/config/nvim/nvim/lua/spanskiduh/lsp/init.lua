local ok1, mason = pcall(require, 'mason')
local ok2, mason_lspconfig = pcall(require, 'mason-lspconfig')
local ok3, cmp = pcall(require, 'cmp')
local ok4, wk = pcall(require, "which-key")

if not (ok1 and ok2 and ok3 and ok4) then return end

-- Command to show all diagnostics (including warnings)
vim.api.nvim_create_user_command("ShowAllDiagnostics", function()
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false
    })
end, {})

-- Command to revert to showing only errors
vim.api.nvim_create_user_command("ShowErrorDiagnostics", function()
    vim.diagnostic.config({
        virtual_text = {severity = {min = vim.diagnostic.severity.ERROR}},
        signs = true,
        underline = {severity = {min = vim.diagnostic.severity.ERROR}},
        update_in_insert = false
    })
end, {})

-- Track which buffers have LSP keybindings registered
local lsp_keybinds_registered = {}

-- Native LSP on_attach function
local function on_attach(client, bufnr)
    if client.name == "eslint" then
        vim.lsp.stop_client(client.id)
        return
    end

    -- Only register keybindings once per buffer
    if lsp_keybinds_registered[bufnr] then return end
    lsp_keybinds_registered[bufnr] = true

    -- Register LSP key mappings for WhichKey
    wk.add({
        {
            "gd",
            function() vim.lsp.buf.definition() end,
            desc = "Go to Definition",
            mode = "n",
            buffer = bufnr
        }, {
            "K",
            function() vim.lsp.buf.hover() end,
            desc = "Hover Documentation",
            mode = "n",
            buffer = bufnr
        }, {
            "<leader>vws",
            function() vim.lsp.buf.workspace_symbol() end,
            desc = "Workspace Symbol",
            mode = "n",
            buffer = bufnr
        }, {
            "<leader>vd",
            function() vim.diagnostic.open_float() end,
            desc = "View Diagnostic",
            mode = "n",
            buffer = bufnr
        }, {
            "[d",
            function() vim.diagnostic.goto_next() end,
            desc = "Next Diagnostic",
            mode = "n",
            buffer = bufnr
        }, {
            "]d",
            function() vim.diagnostic.goto_prev() end,
            desc = "Previous Diagnostic",
            mode = "n",
            buffer = bufnr
        }, {
            "<leader>vca",
            function() vim.lsp.buf.code_action() end,
            desc = "Code Action",
            mode = "n",
            buffer = bufnr
        }, {
            "<leader>vrr",
            function() vim.lsp.buf.references() end,
            desc = "References",
            mode = "n",
            buffer = bufnr
        }, {
            "<leader>vrn",
            function() vim.lsp.buf.rename() end,
            desc = "Rename Symbol",
            mode = "n",
            buffer = bufnr
        }, {
            "<C-h>",
            function() vim.lsp.buf.signature_help() end,
            desc = "Signature Help",
            mode = "i",
            buffer = bufnr
        }, {
            "<leader>sd",
            function() vim.cmd("ShowAllDiagnostics") end,
            desc = "Show Line Diagnostics",
            mode = "n",
            buffer = bufnr
        }, {
            "<leader>hd",
            function() vim.cmd("ShowErrorDiagnostics") end,
            desc = "Hide Line Diagnostics",
            mode = "n",
            buffer = bufnr
        }
    })
end

-- Mason setup for installing and configuring LSP servers
mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

mason_lspconfig.setup({
    ensure_installed = {'rust_analyzer', 'pylsp', 'marksman'},
    automatic_installation = true
})

-- Native LSP setup with capabilities (Neovim 0.11+ compatible)
local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Check if we have the new vim.lsp.config API (Neovim 0.11+)
if vim.lsp.config then
    -- Use new native API
    local servers = {
        rust_analyzer = {
            cmd = {'rust-analyzer'},
            filetypes = {'rust'},
            root_patterns = {'Cargo.toml', 'rust-project.json'}
        },
        pylsp = {
            cmd = {'pylsp'},
            filetypes = {'python'},
            root_patterns = {
                'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt',
                'Pipfile'
            }
        },
        marksman = {
            cmd = {'marksman', 'server'},
            filetypes = {'markdown'},
            root_patterns = {'.marksman.toml', '.git'}
        }
    }

    for server_name, config in pairs(servers) do
        vim.lsp.config[server_name] = vim.tbl_extend('force', config, {
            capabilities = lsp_capabilities,
            on_attach = on_attach
        })
    end

    -- Auto-start LSP servers for appropriate filetypes
    vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
            local filetype = args.match
            for server_name, config in pairs(servers) do
                if vim.tbl_contains(config.filetypes or {}, filetype) then
                    vim.lsp.enable(server_name)
                end
            end
        end
    })
else
    -- Fallback to lspconfig for older versions
    local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
    if ok_lspconfig then
        local servers = {'rust_analyzer', 'pylsp', 'marksman'}
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = lsp_capabilities,
                on_attach = on_attach
            })
        end
    end
end

-- Set up nvim-cmp for completion
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = {
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({select = true}),
    ["<C-Space>"] = cmp.mapping.complete(),
    ['<Tab>'] = nil,
    ['<S-Tab>'] = nil
}
cmp.setup({
    mapping = cmp_mappings,
    sources = {
        {name = 'nvim_lsp'}, {name = 'cmp_r'}, {name = 'path'},
        {name = 'buffer'}, {name = 'luasnip'}
    }
})

-- R-specific completion setup
local ok_r, cmp_r = pcall(require, 'cmp_r')
if ok_r then cmp_r.setup({filetypes = {'r', 'rmd', 'quarto'}, doc_width = 58}) end

-- LuaSnip configuration (minimal setup to avoid jsregexp warnings)
local ok_luasnip, luasnip = pcall(require, 'luasnip')
if ok_luasnip then
    -- Simple configuration that doesn't break LuaSnip
    luasnip.config.setup({
        -- Keep minimal required events
        update_events = "TextChanged,TextChangedI",
        -- Disable features that might use jsregexp
        enable_autosnippets = false
    })

    -- Load friendly snippets
    local ok_friendly, friendly = pcall(require, 'luasnip.loaders.from_vscode')
    if ok_friendly then friendly.lazy_load() end
end

-- Diagnostic configuration for Neovim LSP
vim.diagnostic.config({
    virtual_text = {severity = {min = vim.diagnostic.severity.ERROR}},
    signs = true,
    underline = {severity = {min = vim.diagnostic.severity.ERROR}},
    update_in_insert = false,
    severity_sort = true
})

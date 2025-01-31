local ok1, lsp_zero = pcall(require, 'lsp-zero')
local ok2, mason = pcall(require, 'mason')
local ok3, mason_lspconfig = pcall(require, 'mason-lspconfig')
local ok4, cmp = pcall(require, 'cmp')
local ok5, wk = pcall(require, "which-key")

if not (ok1 and ok2 and ok3 and ok4 and ok5) then return end

-- Extend lspconfig with lsp-zero's functionalities
lsp_zero.extend_lspconfig()

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

-- Default on_attach function with WhichKey mappings
lsp_zero.on_attach(function(client, bufnr)
    if client.name == "eslint" then
        vim.cmd [[ LspStop eslint ]]
        return
    end

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
end)

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
    ensure_installed = {
        'rust_analyzer', 'pylsp', 'r_language_server', 'marksman', 'ltex'
    },
    handlers = {lsp_zero.default_setup}
})

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
    sources = {{name = 'nvim_lsp'}, {name = 'path'}}
})

-- Diagnostic configuration for Neovim LSP
vim.diagnostic.config({
    virtual_text = {severity = {min = vim.diagnostic.severity.ERROR}},
    signs = true,
    underline = {severity = {min = vim.diagnostic.severity.ERROR}},
    update_in_insert = false,
    severity_sort = true
})

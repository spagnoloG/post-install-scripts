local M = {}

local servers = {"lua_ls", "marksman", "rust_analyzer"}

local function lsp_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then return cmp_nvim_lsp.default_capabilities() end
    return vim.lsp.protocol.make_client_capabilities()
end

local function set_lsp_keymaps(bufnr)
    if vim.b[bufnr].spanskiduh_lsp_keymaps then return end
    vim.b[bufnr].spanskiduh_lsp_keymaps = true

    local opts = {buffer = bufnr, silent = true}

    vim.keymap.set("n", "gd", vim.lsp.buf.definition,
                   vim.tbl_extend("force", opts, {desc = "LSP Definition"}))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
                   vim.tbl_extend("force", opts, {desc = "LSP Declaration"}))
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
                   vim.tbl_extend("force", opts, {desc = "LSP Implementation"}))
    vim.keymap.set("n", "gr", vim.lsp.buf.references,
                   vim.tbl_extend("force", opts, {desc = "LSP References"}))
    vim.keymap.set("n", "K", vim.lsp.buf.hover,
                   vim.tbl_extend("force", opts, {desc = "LSP Hover"}))
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help,
                   vim.tbl_extend("force", opts, {desc = "LSP Signature Help"}))
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action,
                   vim.tbl_extend("force", opts, {desc = "LSP Code Action"}))
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float,
                   vim.tbl_extend("force", opts, {desc = "Line Diagnostics"}))
    vim.keymap.set("n", "<leader>lf",
                   function() vim.lsp.buf.format({async = true}) end,
                   vim.tbl_extend("force", opts, {desc = "LSP Format"}))
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,
                   vim.tbl_extend("force", opts, {desc = "LSP Rename"}))
    vim.keymap.set("n", "<leader>ls", vim.lsp.buf.workspace_symbol,
                   vim.tbl_extend("force", opts, {desc = "Workspace Symbols"}))
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force",
                                                                       opts, {
        desc = "Previous Diagnostic"
    }))
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
                   vim.tbl_extend("force", opts, {desc = "Next Diagnostic"}))
end

function M.setup()
    vim.diagnostic.config({
        severity_sort = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        float = {border = "rounded", source = "if_many"},
        virtual_text = {
            source = "if_many",
            spacing = 2,
            severity = {min = vim.diagnostic.severity.ERROR}
        }
    })

    local augroup = vim.api
                        .nvim_create_augroup("spanskiduh-lsp", {clear = true})

    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        callback = function(args) set_lsp_keymaps(args.buf) end
    })

    vim.lsp.config("*", {capabilities = lsp_capabilities()})

    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = {version = "LuaJIT"},
                completion = {callSnippet = "Replace"},
                diagnostics = {globals = {"vim"}},
                workspace = {
                    checkThirdParty = false,
                    library = {vim.env.VIMRUNTIME}
                }
            }
        }
    })

    vim.lsp.config("rust_analyzer", {
        settings = {["rust-analyzer"] = {cargo = {allFeatures = true}}}
    })

    for _, server in ipairs(servers) do vim.lsp.enable(server) end
end

function M.setup_cmp()
    local ok_cmp, cmp = pcall(require, "cmp")
    if not ok_cmp then return end

    local ok_luasnip, luasnip = pcall(require, "luasnip")
    local ok_cmp_r, cmp_r = pcall(require, "cmp_r")

    if ok_luasnip then
        luasnip.config.setup({
            update_events = "TextChanged,TextChangedI",
            enable_autosnippets = false
        })

        local ok_loader, vscode_loader = pcall(require,
                                               "luasnip.loaders.from_vscode")
        if ok_loader then vscode_loader.lazy_load() end
    end

    local sources = {{name = "nvim_lsp"}, {name = "path"}, {name = "buffer"}}

    if ok_luasnip then table.insert(sources, {name = "luasnip"}) end

    local cmp_select = {behavior = cmp.SelectBehavior.Select}

    cmp.setup({
        snippet = {
            expand = function(args)
                if ok_luasnip then
                    luasnip.lsp_expand(args.body)
                elseif vim.snippet and vim.snippet.expand then
                    vim.snippet.expand(args.body)
                end
            end
        },
        mapping = {
            ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
            ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
            ["<C-y>"] = cmp.mapping.confirm({select = true}),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<Tab>"] = nil,
            ["<S-Tab>"] = nil
        },
        sources = sources
    })

    if ok_cmp_r then
        cmp_r.setup({filetypes = {"r", "rmd", "quarto"}, doc_width = 58})

        local r_sources = vim.list_extend({{name = "cmp_r"}},
                                          vim.deepcopy(sources))
        for _, filetype in ipairs({"r", "rmd", "quarto"}) do
            cmp.setup.filetype(filetype, {sources = r_sources})
        end
    end
end

return M

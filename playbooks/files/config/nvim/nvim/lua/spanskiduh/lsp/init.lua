local M = {}

local servers = {"lua_ls", "marksman", "rust_analyzer", "pylsp"}
local diagnostic_virtual_text_mode_index = 2

local function lsp_capabilities()
    local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if ok then return cmp_nvim_lsp.default_capabilities() end
    return vim.lsp.protocol.make_client_capabilities()
end

local function diagnostic_virtual_text_config(min_severity)
    local config = {source = "if_many", spacing = 2}
    if min_severity then config.severity = {min = min_severity} end
    return config
end

local diagnostic_virtual_text_modes = {
    {name = "off", label = "off", value = false},
    {
        name = "errors",
        label = "errors only",
        value = diagnostic_virtual_text_config(vim.diagnostic.severity.ERROR)
    },
    {
        name = "warnings",
        label = "warnings and errors",
        value = diagnostic_virtual_text_config(vim.diagnostic.severity.WARN)
    },
    {
        name = "info",
        label = "info, warnings, and errors",
        value = diagnostic_virtual_text_config(vim.diagnostic.severity.INFO)
    },
    {name = "all", label = "all severities", value = diagnostic_virtual_text_config()}
}

local function set_diagnostic_virtual_text_mode(target, quiet)
    local index = target
    if type(target) == "string" then
        index = nil
        for i, mode in ipairs(diagnostic_virtual_text_modes) do
            if mode.name == target then
                index = i
                break
            end
        end
    end

    local mode = index and diagnostic_virtual_text_modes[index]
    if not mode then return end

    diagnostic_virtual_text_mode_index = index
    vim.diagnostic.config({
        virtual_text = mode.value and vim.deepcopy(mode.value) or false
    })

    if not quiet then
        vim.api.nvim_echo({{
            "Diagnostic virtual text: " .. mode.label, "Normal"
        }}, false, {})
    end
end

local function cycle_diagnostic_virtual_text_mode()
    local next_index = diagnostic_virtual_text_mode_index + 1
    if next_index > #diagnostic_virtual_text_modes then next_index = 1 end
    set_diagnostic_virtual_text_mode(next_index)
end

local function create_diagnostic_user_commands()
    local commands = {
        CycleDiagnosticVirtualText = cycle_diagnostic_virtual_text_mode,
        ShowAllDiagnostics = function()
            set_diagnostic_virtual_text_mode("all")
        end,
        ShowErrorDiagnostics = function()
            set_diagnostic_virtual_text_mode("errors")
        end
    }

    for name, callback in pairs(commands) do
        pcall(vim.api.nvim_del_user_command, name)
        vim.api.nvim_create_user_command(name, callback, {})
    end
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
    vim.keymap.set("n", "<leader>lt", cycle_diagnostic_virtual_text_mode,
                   vim.tbl_extend("force", opts, {
        desc = "Cycle diagnostic virtual text"
    }))
    vim.keymap.set("n", "<leader>lT", function()
        set_diagnostic_virtual_text_mode("errors")
    end, vim.tbl_extend("force", opts, {
        desc = "Reset diagnostic virtual text"
    }))
    vim.keymap.set("n", "<leader>sd", function()
        set_diagnostic_virtual_text_mode("all")
    end, vim.tbl_extend("force", opts, {
        desc = "Show all diagnostic virtual text"
    }))
    vim.keymap.set("n", "<leader>hd", function()
        set_diagnostic_virtual_text_mode("errors")
    end, vim.tbl_extend("force", opts, {
        desc = "Show only error virtual text"
    }))
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
        underline = false, -- false!!!
        update_in_insert = false,
        float = {border = "rounded", source = "if_many"},
        virtual_text = diagnostic_virtual_text_modes[diagnostic_virtual_text_mode_index].value
    })

    local augroup = vim.api
                        .nvim_create_augroup("spanskiduh-lsp", {clear = true})

    create_diagnostic_user_commands()

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

    vim.lsp.config("pylsp", {
        cmd = {vim.fn.stdpath("data") .. "/mason/bin/pylsp"},
        root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, {
                "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
                "Pipfile", ".git"
            })
            local file = vim.api.nvim_buf_get_name(bufnr)

            on_dir(root or vim.fs.dirname(file))
        end,
        settings = {
            pylsp = {
                plugins = {
                    pycodestyle = {maxLineLength = 100}
                }
            }
        }
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

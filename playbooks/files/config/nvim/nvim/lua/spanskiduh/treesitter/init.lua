local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if not ok then return end

local function patch_query_directives()
    local ok_query, query = pcall(require, "vim.treesitter.query")

    if not ok_query then return end

    local opts = vim.fn.has("nvim-0.10") == 1 and {force = true, all = false} or true
    local html_script_type_languages = {
        importmap = "json",
        module = "javascript",
        ["application/ecmascript"] = "javascript",
        ["text/ecmascript"] = "javascript"
    }
    local non_filetype_match_injection_language_aliases = {
        ex = "elixir",
        pl = "perl",
        sh = "bash",
        ts = "typescript",
        uxn = "uxntal"
    }

    local function get_capture_node(match, capture_id)
        local node = match[capture_id]

        if type(node) == "table" then return node[1] end

        return node
    end

    local function get_parser_from_markdown_info_string(injection_alias)
        local match = vim.filetype.match {filename = "a." .. injection_alias}

        return match or non_filetype_match_injection_language_aliases[injection_alias] or
                   injection_alias
    end

    -- Neovim 0.12 passes TSNode[] into custom directives; legacy nvim-treesitter
    -- directives still expect a single TSNode and crash on markdown injections.
    query.add_directive("set-lang-from-mimetype!",
                        function(match, _, bufnr, pred, metadata)
        local node = get_capture_node(match, pred[2])

        if not node then return end

        local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
        local configured = html_script_type_languages[type_attr_value]

        if configured then
            metadata["injection.language"] = configured
            return
        end

        local parts = vim.split(type_attr_value, "/", {})
        metadata["injection.language"] = parts[#parts]
    end, opts)

    query.add_directive("set-lang-from-info-string!",
                        function(match, _, bufnr, pred, metadata)
        local node = get_capture_node(match, pred[2])

        if not node then return end

        local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata["injection.language"] = get_parser_from_markdown_info_string(
                                            injection_alias)
    end, opts)

    query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = get_capture_node(match, id)

        if not node then return end

        metadata[id] = metadata[id] or {}
        metadata[id].text = string.lower(vim.treesitter.get_node_text(node, bufnr, {
            metadata = metadata[id]
        }) or "")
    end, opts)
end

patch_query_directives()

treesitter.setup {
    -- A list of parser names, or "all" (removed parsers that need CLI compilation)
    ensure_installed = {
        "c", "lua", "rust", "javascript", "java", "python", "html", "css",
        "json", "yaml", "bash", "typescript", "r", "markdown",
        "markdown_inline", "vim", "vimdoc"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Disable auto_install since we don't have tree-sitter CLI
    auto_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
        enable = true,
        -- Keep Tree-sitter in charge of syntax colors to avoid muddy overlaps.
        additional_vim_regex_highlighting = false,
        -- Disable highlighting for very large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local uv = vim.uv or vim.loop
            local ok, stats = pcall(uv.fs_stat,
                                    vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                return true
            end
        end
    },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    },

    indent = {
        enable = true,
        -- Disable indent for some languages that have issues
        disable = {"yaml"}
    }
}

-- Create a command to manually install missing parsers (CLI-dependent ones)
vim.api.nvim_create_user_command('TSInstallMissing', function()
    local parsers = {"rnoweb", "latex"}
    vim.notify("Installing CLI-dependent parsers: " ..
                   table.concat(parsers, ", "), vim.log.levels.INFO)
    for _, parser in ipairs(parsers) do vim.cmd('TSInstall ' .. parser) end
end, {desc = "Install missing treesitter parsers (rnoweb, latex)"})

-- Note: Automatic parser installation disabled to avoid CLI dependency
-- To manually install missing parsers, run: :TSInstall <parser_name>
-- Or use the provided commands: :TSInstallMissing or :TSInstallMissingSync

-- Also provide a synchronous installation command
vim.api.nvim_create_user_command('TSInstallMissingSync', function()
    local parsers = {"rnoweb", "latex"}
    for _, parser in ipairs(parsers) do
        vim.notify("Installing " .. parser .. "...", vim.log.levels.INFO)
        local ok, result = pcall(vim.cmd, 'TSInstall! ' .. parser)
        if ok then
            vim.notify("✓ Installed " .. parser, vim.log.levels.INFO)
        else
            vim.notify("✗ Failed to install " .. parser .. ": " ..
                           tostring(result), vim.log.levels.ERROR)
        end
    end
end, {desc = "Synchronously install missing treesitter parsers (rnoweb, latex)"})

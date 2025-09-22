local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if not ok then return end

treesitter.setup {
    -- A list of parser names, or "all" (removed parsers that need CLI compilation)
    ensure_installed = {
        "c", "lua", "rust", "javascript", "java", "python", "html", "css",
        "json", "yaml", "bash", "typescript", "r", "markdown", "vim", "vimdoc"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Disable auto_install since we don't have tree-sitter CLI
    auto_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        -- Disable highlighting for very large files
        disable = function(lang, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat,
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

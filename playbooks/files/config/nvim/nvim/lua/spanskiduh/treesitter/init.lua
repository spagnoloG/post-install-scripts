local ok, treesitter = pcall(require, "nvim-treesitter.configs")

if not ok then return end

treesitter.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        "c", "lua", "rust", "javascript", "java", "python", "html", "css",
        "json", "yaml", "bash", "typescript", "r", "markdown", "rnoweb",
        "latex", "vim", "vimdoc"
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

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

-- Create a command to manually install missing parsers
vim.api.nvim_create_user_command('TSInstallMissing', function()
    local parsers = {"r", "rnoweb", "latex", "yaml"}
    for _, parser in ipairs(parsers) do vim.cmd('TSInstall ' .. parser) end
end, {desc = "Install missing treesitter parsers"})

-- Auto-install missing parsers on startup (with error handling)
vim.defer_fn(function()
    local parsers_to_check = {"r", "rnoweb", "latex", "yaml"}

    for _, parser in ipairs(parsers_to_check) do
        -- Check if parser is already installed
        local has_parser = false
        local ok_check = pcall(function()
            vim.treesitter.language.require_language(parser)
            has_parser = true
        end)

        if not has_parser then
            -- Try to install the parser
            vim.notify("Installing treesitter parser for " .. parser .. "...",
                       vim.log.levels.INFO)
            vim.schedule(function()
                local install_ok, install_result = pcall(vim.cmd,
                                                         'TSInstall ' .. parser)
                if install_ok then
                    vim.notify("Successfully installed " .. parser .. " parser",
                               vim.log.levels.INFO)
                else
                    vim.notify("Failed to install " .. parser .. " parser: " ..
                                   tostring(install_result), vim.log.levels.WARN)
                end
            end)
        end
    end
end, 2000) -- Increased delay to ensure treesitter is fully loaded

-- Also provide a synchronous installation command
vim.api.nvim_create_user_command('TSInstallMissingSync', function()
    local parsers = {"r", "rnoweb", "latex", "yaml"}
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
end, {desc = "Synchronously install missing treesitter parsers"})

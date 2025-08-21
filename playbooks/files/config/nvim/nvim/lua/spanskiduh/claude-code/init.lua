local ok, claude_code = pcall(require, "claude-code")
local ok_wk, wk = pcall(require, "which-key")

if not ok then return end

-- Claude Code setup with configuration that integrates with existing setup
claude_code.setup({
    -- Terminal window settings
    window = {
        split_ratio = 0.4, -- Percentage of screen for the terminal window
        position = "botright", -- Position of the window
        enter_insert = true, -- Enter insert mode when opening Claude Code
        hide_numbers = true, -- Hide line numbers in the terminal window
        hide_signcolumn = true, -- Hide the sign column in the terminal window

        -- Floating window configuration (alternative option)
        float = {
            width = "85%", -- Width: percentage of editor width
            height = "85%", -- Height: percentage of editor height
            row = "center", -- Center vertically
            col = "center", -- Center horizontally
            relative = "editor", -- Relative to editor
            border = "rounded" -- Rounded border style
        }
    },
    -- File refresh settings
    refresh = {
        enable = true, -- Enable file change detection
        updatetime = 100, -- updatetime when Claude Code is active
        timer_interval = 1000, -- How often to check for file changes
        show_notifications = true -- Show notification when files are reloaded
    },
    -- Git project settings
    git = {
        use_git_root = true -- Set CWD to git root when opening Claude Code
    },
    -- Shell-specific settings
    shell = {
        separator = '&&', -- Command separator for bash/zsh
        pushd_cmd = 'pushd', -- Command to push directory onto stack
        popd_cmd = 'popd' -- Command to pop directory from stack
    },
    -- Command settings
    command = "claude", -- Command used to launch Claude Code
    -- Command variants
    command_variants = {
        -- Conversation management
        continue = "--continue", -- Resume the most recent conversation
        resume = "--resume", -- Display an interactive conversation picker
        -- Output options
        verbose = "--verbose" -- Enable verbose logging with full turn-by-turn output
    },
    -- Keymaps
    keymaps = {
        toggle = {
            normal = "<leader>cc", -- Normal mode keymap for toggling Claude Code
            terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code
            variants = {
                continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
                verbose = "<leader>cV" -- Normal mode keymap for Claude Code with verbose flag
            }
        },
        window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
        scrolling = true -- Enable scrolling keymaps (<C-f/b>) for page up/down
    }
})

-- Register Claude Code key mappings with WhichKey if available
if ok_wk then
    wk.add({
        {
            "<leader>cc",
            "<cmd>ClaudeCode<CR>",
            desc = "Toggle Claude Code",
            mode = "n"
        }, {
            "<leader>cC",
            "<cmd>ClaudeCodeContinue<CR>",
            desc = "Claude Code Continue",
            mode = "n"
        }, {
            "<leader>cV",
            "<cmd>ClaudeCodeVerbose<CR>",
            desc = "Claude Code Verbose",
            mode = "n"
        }, {
            "<leader>cr",
            "<cmd>ClaudeCodeResume<CR>",
            desc = "Claude Code Resume",
            mode = "n"
        }
    })
end

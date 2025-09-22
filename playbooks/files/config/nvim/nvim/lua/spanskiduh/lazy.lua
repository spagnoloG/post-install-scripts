-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo,
        lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            {"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
            {"\nPress any key to exit..."}
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with plugin specifications
require("lazy").setup({
    spec = {
        -- Telescope fuzzy finder
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = {
                "nvim-lua/plenary.nvim", -- FZF native for performance
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    build = "make",
                    cond = function()
                        return vim.fn.executable("make") == 1
                    end
                }
            },
            config = function() require("spanskiduh.telescope") end,
            cmd = "Telescope",
            keys = {
                {
                    "<leader>ff",
                    "<cmd>Telescope find_files<cr>",
                    desc = "Find Files"
                },
                {"<C-p>", "<cmd>Telescope git_files<cr>", desc = "Git Files"},
                {
                    "<leader>fg",
                    "<cmd>Telescope live_grep<cr>",
                    desc = "Live Grep"
                }
            }
        }, -- Colorscheme
        {
            "Mofiqul/dracula.nvim",
            lazy = false,
            priority = 1000,
            config = function()
                -- Safe colorscheme loading with fallback
                local ok, _ = pcall(vim.cmd.colorscheme, "dracula")
                if not ok then
                    vim.cmd.colorscheme("default")
                    vim.notify(
                        "Failed to load dracula colorscheme, using default",
                        vim.log.levels.WARN)
                end
            end
        }, -- Treesitter for syntax highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            event = {"BufReadPre", "BufNewFile"},
            config = function() require("spanskiduh.treesitter") end
        }, -- Undotree for undo history visualization
        {
            "mbbill/undotree",
            cmd = "UndotreeToggle",
            keys = {
                {"<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle Undotree"}
            }
        }, -- Git integration
        {
            "tpope/vim-fugitive",
            cmd = {"Git", "Gdiffsplit", "Gwrite", "GDelete"},
            keys = {{"<leader>gs", vim.cmd.Git, desc = "Git Status"}}
        }, -- LSP Support (conditionally load lspconfig for compatibility)
        {
            "neovim/nvim-lspconfig",
            cond = function()
                -- Only load lspconfig if we don't have native vim.lsp.config
                return not vim.lsp.config
            end,
            cmd = {"LspInfo", "LspInstall", "LspStart"},
            event = {"BufReadPre", "BufNewFile"},
            dependencies = {
                {"hrsh7th/cmp-nvim-lsp"}, {"williamboman/mason-lspconfig.nvim"}
            },
            config = function() require("spanskiduh.lsp") end
        }, -- Native LSP configuration (for Neovim 0.11+)
        {
            "hrsh7th/cmp-nvim-lsp",
            cond = function()
                -- Load native LSP setup if we have vim.lsp.config
                return vim.lsp.config ~= nil
            end,
            event = {"BufReadPre", "BufNewFile"},
            dependencies = {{"williamboman/mason-lspconfig.nvim"}},
            config = function() require("spanskiduh.lsp") end
        }, -- Mason for LSP server management
        {
            "williamboman/mason.nvim",
            lazy = false,
            config = function() require("mason").setup() end
        }, -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                {"L3MON4D3/LuaSnip"}, {"hrsh7th/cmp-buffer"},
                {"hrsh7th/cmp-path"}, {"saadparwaiz1/cmp_luasnip"},
                {"hrsh7th/cmp-nvim-lsp"}, {"hrsh7th/cmp-nvim-lua"},
                {"rafamadriz/friendly-snippets"}
            }
        }, -- LaTeX support
        {
            "lervag/vimtex",
            lazy = false, -- VimTeX should not be lazy-loaded
            ft = {"tex", "latex"},
            config = function() require("spanskiduh.vimtex") end
        }, -- File explorer
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons",
                "MunifTanjim/nui.nvim"
            },
            cmd = "Neotree",
            keys = {
                {"<leader>nt", ":Neotree toggle<CR>", desc = "Toggle Neotree"}
            },
            config = function() require("spanskiduh.neotree") end
        }, -- Git signs in the gutter
        {
            "lewis6991/gitsigns.nvim",
            event = {"BufReadPre", "BufNewFile"},
            config = function() require("spanskiduh.gitsigns") end
        }, -- GitHub Copilot
        {"github/copilot.vim", event = "InsertEnter"}, -- R language support
        {
            "R-nvim/R.nvim",
            lazy = false,
            version = "~1.0.0",
            ft = {"r", "rmd", "quarto"},
            config = function() require("spanskiduh.rnvim") end
        }, -- R completion
        {
            "R-nvim/cmp-r",
            ft = {"r", "rmd", "quarto"},
            dependencies = {"hrsh7th/nvim-cmp"}
        }, -- Which-key for keybinding hints
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            config = function() require("spanskiduh.which-key") end
        }, -- Claude Code AI assistant
        {
            "greggh/claude-code.nvim",
            dependencies = {"nvim-lua/plenary.nvim"},
            config = function() require("spanskiduh.claude-code") end,
            keys = {
                {
                    "<leader>cc",
                    "<cmd>ClaudeCode<CR>",
                    desc = "Toggle Claude Code"
                },
                {
                    "<leader>cC",
                    "<cmd>ClaudeCodeContinue<CR>",
                    desc = "Claude Code Continue"
                },
                {
                    "<leader>cV",
                    "<cmd>ClaudeCodeVerbose<CR>",
                    desc = "Claude Code Verbose"
                },
                {
                    "<leader>cr",
                    "<cmd>ClaudeCodeResume<CR>",
                    desc = "Claude Code Resume"
                }
            }
        }
    },

    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = false -- always use the latest git commit
    },

    install = {colorscheme = {"dracula"}},

    checker = {
        enabled = true, -- automatically check for plugin updates
        notify = false -- don't notify about updates
    },

    rocks = {
        enabled = false -- disable luarocks support since we don't need it
    },

    performance = {
        cache = {enabled = true},
        reset_packpath = true, -- reset the package path to improve startup time
        rtp = {
            reset = true, -- reset the runtime path to improve startup time
            paths = {}, -- add any custom paths here that you want to includes in the rtp
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin",
                "tohtml", "tutor", "zipPlugin"
            }
        }
    }
})

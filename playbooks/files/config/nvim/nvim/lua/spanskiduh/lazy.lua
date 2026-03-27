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
            "rebelot/kanagawa.nvim",
            lazy = false,
            priority = 1000,
            config = function() require("spanskiduh.kanagawa").load() end
        }, -- Treesitter for syntax highlighting
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            event = {"BufReadPre", "BufNewFile"},
            config = function() require("spanskiduh.treesitter") end
        }, -- CSV/TSV table view
        {
            "hat0uma/csvview.nvim",
            ft = {"csv", "tsv"},
            cmd = {"CsvViewEnable", "CsvViewDisable", "CsvViewToggle", "CsvViewInfo"},
            config = function() require("spanskiduh.csvview").setup() end
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
        }, -- Mason package manager
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            }
        }, -- Mason bridge for LSP servers
        {
            "mason-org/mason-lspconfig.nvim",
            dependencies = {{"mason-org/mason.nvim"}, {"neovim/nvim-lspconfig"}},
            opts = {
                ensure_installed = {"lua_ls", "marksman", "rust_analyzer", "pylsp"},
                automatic_enable = false
            }
        }, -- LSP configuration (Neovim 0.11+)
        {
            "neovim/nvim-lspconfig",
            dependencies = {{"hrsh7th/cmp-nvim-lsp"}},
            config = function() require("spanskiduh.lsp").setup() end
        }, -- Autocompletion
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                {"L3MON4D3/LuaSnip"}, {"hrsh7th/cmp-buffer"},
                {"hrsh7th/cmp-path"}, {"saadparwaiz1/cmp_luasnip"},
                {"hrsh7th/cmp-nvim-lsp"}, {"rafamadriz/friendly-snippets"},
                {"R-nvim/cmp-r"}
            },
            config = function() require("spanskiduh.lsp").setup_cmp() end
        }, -- LaTeX support
        {
            "lervag/vimtex",
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
            version = "~1.0.0",
            ft = {"r", "rmd", "quarto"},
            config = function() require("spanskiduh.rnvim") end
        }, {
            "folke/which-key.nvim",
            event = "VeryLazy",
            config = function() require("spanskiduh.which-key") end
        }
    },

    defaults = {
        lazy = false, -- should plugins be lazy-loaded?
        version = false -- always use the latest git commit
    },

    install = {colorscheme = {"kanagawa"}},

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
                "gzip", "matchit", "matchparen", "tarPlugin", "tohtml", "tutor",
                "zipPlugin"
            }
        }
    }
})

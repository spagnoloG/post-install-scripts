local ok1, telescope = pcall(require, "telescope")
local ok2, telescope_builtin = pcall(require, "telescope.builtin")
local ok3, wk = pcall(require, "which-key")

if not (ok1 and ok2 and ok3) then return end

-- Register Telescope key mappings with WhichKey
wk.add({
    {
        "<leader>ff",
        telescope_builtin.find_files,
        desc = "🔍 Find Files",
        mode = "n"
    },
    {"<C-p>", telescope_builtin.git_files, desc = "📁 Git Files", mode = "n"},
    {
        "<leader>fg",
        telescope_builtin.live_grep,
        desc = "🔍 Live Grep",
        mode = "n"
    }
})

-- Telescope setup
telescope.setup {
    picker = {hidden = true},
    defaults = {
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--no-ignore", "--smart-case",
            "--hidden"
        },
        file_ignore_patterns = {
            ".git/", ".settings/", ".metadata/", "target/", "node_modules/",
            '.class$', '.venv/', '.DS_Store', 'dist/', 'build/', 'coverage/'
        },
        mappings = {i = {['<C-u>'] = false, ['<C-d>'] = false}},
        layout_strategy = "horizontal",
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = {"absolute"},
        color_devicons = true,
        use_less = true,
        set_env = {["COLORTERM"] = "truecolor"},
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    }
}

-- Load fzf extension for performance
pcall(telescope.load_extension, "fzf")

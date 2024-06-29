local ok, neotree = pcall(require, "neo-tree")

if not ok then return end

neotree.setup {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,

    default_component_configs = {
        container = {enable_character_fade = true},
        indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander"
        },
        icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            default = "*",
            highlight = "NeoTreeFileIcon"
        },
        modified = {symbol = "[+]", highlight = "NeoTreeModified"},
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName"
        },
        git_status = {
            symbols = {
                added = "",
                modified = "",
                deleted = "✖",
                renamed = "󰁕",
                untracked = "",
                ignored = "",
                unstaged = "󰄱",
                staged = "",
                conflict = ""
            }
        },
        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
            enabled = true,
            required_width = 64 -- min width of window required to show this column
        },
        type = {
            enabled = true,
            required_width = 122 -- min width of window required to show this column
        },
        last_modified = {
            enabled = true,
            required_width = 88 -- min width of window required to show this column
        },
        created = {
            enabled = true,
            required_width = 110 -- min width of window required to show this column
        },
        symlink_target = {enabled = false}
    },
    buffers = {
        follow_current_file = true, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
        show_unloaded = true,
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["t"] = "open_tabnew",
                ["l"] = "focus_preview",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["<cr>"] = "open",
                ["<esc>"] = "cancel", -- close preview or floating neo-tree window
                ["P"] = {
                    "toggle_preview",
                    config = {use_float = true, use_image_nvim = true}
                },
                -- Read `# Preview Mode` for more information
                ["l"] = "focus_preview",
                ["S"] = "open_split",
                ["s"] = "open_vsplit"
            }
        }
    },
    filesystem = {
        filtered_items = {
            visible = true, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false, -- only works on Windows for hidden files/directories
            hide_by_name = {
                -- "node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
                -- "*.meta"
            },
            never_show = { -- remains hidden even if visible is toggled to true
                -- ".DS_Store",
                -- "thumbs.db"
            }
        },
        follow_current_file = true, -- This will find and focus the file in the active buffer every
        -- time the current file is changed while the tree is open.
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
        -- instead of relying on nvim autocmd events.
        window = {
            mappings = {
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
                ["H"] = "toggle_hidden",
                ["/"] = "fuzzy_finder",
                ["f"] = "filter_on_submit",
                ["<c-x>"] = "clear_filter",
                ["[g"] = "prev_git_modified",
                ["]g"] = "next_git_modified",
                ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
                ["d"] = "delete",
                ["r"] = "rename",
                ["y"] = "copy_to_clipboard",
                ["x"] = "cut_to_clipboard",
                ["p"] = "paste_from_clipboard",
                ["t"] = "open_tabnew",
                ["l"] = "focus_preview",
                ["S"] = "open_split",
                ["s"] = "open_vsplit",
                ["<cr>"] = "open",
                ["<esc>"] = "cancel", -- close preview or floating neo-tree window
                ["P"] = {
                    "toggle_preview",
                    config = {use_float = true, use_image_nvim = true}
                },
                -- Read `# Preview Mode` for more information
                ["l"] = "focus_preview",
                ["S"] = "open_split",
                ["s"] = "open_vsplit"
            }
        }
    },
    git_status = {
        window = {
            position = "float",
            mappings = {
                ["A"] = "git_add_all",
                ["gu"] = "git_unstage_file",
                ["ga"] = "git_add_file",
                ["gr"] = "git_revert_file",
                ["gc"] = "git_commit",
                ["gp"] = "git_push",
                ["gg"] = "git_commit_and_push",
                ["o"] = {
                    "show_help",
                    nowait = false,
                    config = {title = "Order by", prefix_key = "o"}
                },
                ["oc"] = {"order_by_created", nowait = false},
                ["od"] = {"order_by_diagnostics", nowait = false},
                ["om"] = {"order_by_modified", nowait = false},
                ["on"] = {"order_by_name", nowait = false},
                ["os"] = {"order_by_size", nowait = false},
                ["ot"] = {"order_by_type", nowait = false}
            }
        }
    }
}

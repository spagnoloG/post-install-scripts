-- remaps
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end)

vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>sr",
               ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {silent = true})

-- Move around windows (shifted to the right)
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Splits
vim.keymap.set("n", "<leader>wh", ":split<CR>")
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>")
vim.keymap.set("n", "<leader>qq", ":q<CR>")

-- Note: Neotree keybinding is in lazy.lua keys section

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Git operations
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>ga", ":Git add %<CR>")
vim.keymap.set("n", "<leader>gA", ":Git add .<CR>")
vim.keymap.set("n", "<leader>gc", ":Git commit<CR>")
vim.keymap.set("n", "<leader>gC", ":Git commit --amend<CR>")
vim.keymap.set("n", "<leader>gp", ":Git push<CR>")
vim.keymap.set("n", "<leader>gP", ":Git pull<CR>")
vim.keymap.set("n", "<leader>gf", ":Git fetch<CR>")
vim.keymap.set("n", "<leader>gl", ":Git log --oneline<CR>")
vim.keymap.set("n", "<leader>gL", ":Git log<CR>")
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>")
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
vim.keymap.set("n", "<leader>gD", ":Git diff<CR>")
vim.keymap.set("n", "<leader>gh", ":diffget //2<CR>")
vim.keymap.set("n", "<leader>gj", ":diffget //3<CR>")
vim.keymap.set("n", "<leader>gm", ":Git merge<CR>")
vim.keymap.set("n", "<leader>gr", ":Git rebase<CR>")
vim.keymap.set("n", "<leader>gR", ":Git reset<CR>")
vim.keymap.set("n", "<leader>gt", ":Git stash<CR>")
vim.keymap.set("n", "<leader>gT", ":Git stash pop<CR>")
vim.keymap.set("n", "<leader>gw", ":Gwrite<CR>")
vim.keymap.set("n", "<leader>gx", ":GDelete<CR>")

-- VimTeX operations
vim.keymap.set("n", "<leader>tc", "<plug>(vimtex-compile)")
vim.keymap.set("n", "<leader>tC", "<plug>(vimtex-compile-ss)")
vim.keymap.set("n", "<leader>tk", "<plug>(vimtex-stop)")
vim.keymap.set("n", "<leader>tK", "<plug>(vimtex-stop-all)")
vim.keymap.set("n", "<leader>te", "<plug>(vimtex-errors)")
vim.keymap.set("n", "<leader>to", "<plug>(vimtex-compile-output)")
vim.keymap.set("n", "<leader>tg", "<plug>(vimtex-status)")
vim.keymap.set("n", "<leader>tG", "<plug>(vimtex-status-all)")
vim.keymap.set("n", "<leader>tv", "<plug>(vimtex-view)")
vim.keymap.set("n", "<leader>tr", "<plug>(vimtex-reverse-search)")
vim.keymap.set("n", "<leader>tl", "<plug>(vimtex-compile-selected)")
vim.keymap.set("x", "<leader>tl", "<plug>(vimtex-compile-selected)")
vim.keymap.set("n", "<leader>ti", "<plug>(vimtex-info)")
vim.keymap.set("n", "<leader>tI", "<plug>(vimtex-info-full)")
vim.keymap.set("n", "<leader>tt", "<plug>(vimtex-toc-open)")
vim.keymap.set("n", "<leader>tT", "<plug>(vimtex-toc-toggle)")
vim.keymap.set("n", "<leader>tq", "<plug>(vimtex-log)")
vim.keymap.set("n", "<leader>ts", "<plug>(vimtex-toggle-main)")
vim.keymap.set("n", "<leader>ta", "<plug>(vimtex-context-menu)")
vim.keymap.set("n", "<leader>tx", "<plug>(vimtex-reload)")
vim.keymap.set("n", "<leader>tX", "<plug>(vimtex-reload-state)")
vim.keymap.set("n", "<leader>tm", "<plug>(vimtex-imaps-list)")
vim.keymap.set("n", "<leader>tw", "<plug>(vimtex-words)")
vim.keymap.set("n", "<leader>td", "<plug>(vimtex-doc-package)")
vim.keymap.set("n", "<leader>tD", "<plug>(vimtex-doc-package-window)")

-- Note: Claude Code keybindings are registered in which-key/init.lua to avoid duplicates

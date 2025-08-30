vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = " "

vim.opt.autoread = true

-- Colorscheme
vim.cmd.colorscheme("dracula")

-- Autosave
vim.cmd('autocmd FocusLost, BufLeave, BufHidden * silent! wall')

-- Auto-reload files when changed externally
vim.cmd([[
  augroup auto_read
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
      \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  augroup END
]])

-- Copilot parse yaml
vim.cmd('filetype on') -- Enable filetype detection
vim.cmd('autocmd BufRead,BufNewFile *.yml,*.yaml set filetype=yaml') -- Set the filetype for YAML files
vim.cmd('autocmd BufRead,BufNewFile *.stan set filetype=stan') -- Set the filetype for Stan files
vim.g.copilot_filetypes = {
    yaml = true,
    yml = true,
    markdown = true,
    stan = true
}

-- Disable unused providers to remove warnings
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

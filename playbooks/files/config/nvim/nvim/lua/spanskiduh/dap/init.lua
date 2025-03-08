local ok_dap, dap = pcall(require, "dap")
local ok_ui, dapui = pcall(require, "dapui")
local ok_python, dap_python = pcall(require, "dap-python")
local ok_vtext, dap_vtext = pcall(require, "nvim-dap-virtual-text")

if not (ok_dap and ok_ui and ok_python and ok_vtext) then return end

-- Set up dap-ui with default options.
dapui.setup({})

-- Set up virtual text for inline variable display.
dap_vtext.setup({
    commented = true -- show virtual text as comments
})

-- Configure Python debugging.
-- Adjust "python3" to your interpreter path if needed (e.g. "python" or a venv path).
dap_python.setup("python3")

vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = ""
})
vim.fn.sign_define("DapBreakpointRejected", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = ""
})
vim.fn.sign_define("DapStopped", {
    text = "",
    texthl = "DiagnosticSignWarn",
    linehl = "Visual",
    numhl = "DiagnosticSignWarn"
})

-- Automatically open/close the DAP UI when debugging sessions start/end.
dap.listeners.after.event_initialized["dapui_config"] =
    function() dapui.open() end
dap.listeners.before.event_terminated["dapui_config"] =
    function() dapui.close() end
dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

local opts = {noremap = true, silent = true}
vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, opts)
vim.keymap.set("n", "<leader>dc", function() dap.continue() end, opts)
vim.keymap.set("n", "<leader>do", function() dap.step_over() end, opts)
vim.keymap.set("n", "<leader>di", function() dap.step_into() end, opts)
vim.keymap.set("n", "<leader>dO", function() dap.step_out() end, opts)
vim.keymap.set("n", "<leader>dq", function() dap.terminate() end, opts)
vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, opts)
vim.keymap.set({"n", "v"}, "<M-e>", function() dapui.eval() end,
               {noremap = true, silent = true, desc = "DAP Eval"})


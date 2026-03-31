local M = {}

function M.setup()
    local ok, smear_cursor = pcall(require, "smear_cursor")
    if not ok then return end

    smear_cursor.setup({
        smear_between_buffers = true,
        smear_between_neighbor_lines = true,
        scroll_buffer_space = true,
        legacy_computing_symbols_support = false,
        smear_insert_mode = true,
        stiffness = 0.85,
        trailing_stiffness = 0.55,
        stiffness_insert_mode = 0.75,
        trailing_stiffness_insert_mode = 0.75,
        damping = 0.9,
        damping_insert_mode = 0.9,
        distance_stop_animating = 0.55
    })
end

return M

local ok1, mark = pcall(require, "harpoon.mark")
local ok2, ui = pcall(require, "harpoon.ui")
local ok3, wk = pcall(require, "which-key")

if not ok1 or not ok2 or not ok3 then return end

-- Register with WhichKey for the popup display
wk.add({
    {
        "<leader>a",
        function() mark.add_file() end,
        desc = "➕ Add File to Harpoon",
        mode = "n"
    }, {
        "<leader>e",
        function() ui.toggle_quick_menu() end,
        desc = "📋 Toggle Harpoon Menu",
        mode = "n"
    }, {
        "<leader>1",
        function() ui.nav_file(1) end,
        desc = "1️⃣ Harpoon File 1",
        mode = "n"
    }, {
        "<leader>2",
        function() ui.nav_file(2) end,
        desc = "2️⃣ Harpoon File 2",
        mode = "n"
    }, {
        "<leader>3",
        function() ui.nav_file(3) end,
        desc = "3️⃣ Harpoon File 3",
        mode = "n"
    }, {
        "<leader>4",
        function() ui.nav_file(4) end,
        desc = "4️⃣ Harpoon File 4",
        mode = "n"
    }
})

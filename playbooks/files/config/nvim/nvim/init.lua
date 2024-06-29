local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                       install_path)

   local success, error_message = pcall(vim.cmd, 'packadd packer.nvim')
   if not success then
     print("Error while loading packer.nvim:", error_message)
   end
end

require("spanskiduh")

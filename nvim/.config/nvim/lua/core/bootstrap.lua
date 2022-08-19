PACKER_INITIALIZED = nil
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_INITIALIZED = false
    Packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    require("core/packages")
    if Packer_bootstrap then
        require('packer').sync()
    end
else
    PACKER_INITIALIZED = true
end

require("core/bootstrap")

if PACKER_INITIALIZED == true then
    require("core/packages")
    require("core/config")
    require("core/post_config")
    require("core/keybindings")
end

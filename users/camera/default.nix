{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.myusers.camera;
in
{
  options = {
    myusers.portable = {
      enable = mkEnableOption "Enable Camera user";
    };
  };

  config = mkIf cfg.enable {
    mypackages.home-manager.enable = true;

    users.mutableUsers = false;
    users.users.camera = {
      createHome = true;
      extraGroups = [ "wheel" "networkmanager" ];
      isNormalUser = true;
      initialPassword = "test";
      shell = pkgs.zsh;
    };

    home-manager.users.szymzal = {
      imports = [ ./home.nix ];
    };
  };
}

{ config, lib, pkgs, ... }:

{

  users.users.szymzal = {
    createHome = true;
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  home-manager.users.szymzal = {
    imports = [ ./home.nix ];
  };

}

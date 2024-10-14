{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.editor;
in
{
  options = {
    mypackages.editor = {
      enable = mkEnableOption "Enable text editor";
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        neovim
      ];
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.audio-mix;
in {
  options = {
    mypackages.audio-mix = {
      enable = mkEnableOption "Enable Audio Mix/Record";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # FIX: https://github.com/NixOS/nixpkgs/issues/368134
      # ardour
    ];

    mypackages.impermanence.directories = [
      ".config/ardour8"
    ];
  };
}

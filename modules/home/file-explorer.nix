{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.file-explorer;
in {
  options = {
    mypackages.file-explorer = {
      enable = mkEnableOption "Enable file explorer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nemo-with-extensions
      nemo-fileroller
      file-roller
    ];

    mypackages.impermanence.directories = [
      ".config/nemo"
    ];
  };
}

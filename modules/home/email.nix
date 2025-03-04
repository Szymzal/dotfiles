{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.email;
in {
  options = {
    mypackages.email = {
      enable = mkEnableOption "Enable desktop email app";
    };
  };

  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-latest;
      profiles = {
        main = {
          isDefault = true;
          settings = {
            "general.useragent.compatMode.firefox" = true;
          };
        };
      };
    };

    mypackages.impermanence.directories = [
      ".thunderbird"
    ];
  };
}

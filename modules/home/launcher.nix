{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.launcher;
in {
  options = {
    mypackages.launcher = {
      enable = mkEnableOption "Enable App/Power launcher";
    };
  };

  config = mkIf cfg.enable (let
    # Copied from https://github.com/danth/stylix/blob/ca3247ed8cfbf369f3fe1b7a421579812a95c101/modules/fuzzel/hm.nix#L25
    font = "${config.stylix.fonts.sansSerif.name}:size=${toString config.stylix.fonts.sizes.popups}:weight=bold";
  in {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.foot}/bin/foot";
          dpi-aware = "no";
          width = 25;
          line-height = 25;
          prompt = "❯ ";
          icon-theme = "${config.mypackages.theme.iconTheme.name}";
          font = mkForce font;
        };

        border = {
          radius = 5;
        };
      };
    };

    home.packages = with pkgs; [
      bemoji
    ];

    mypackages.impermanence.directories = [
      ".config/networkmanager-dmenu"
    ];

    home.file = {
      ".config/networkmanager-dmenu/config.ini".text = ''
        [dmenu]
        dmenu_command = ${pkgs.fuzzel}/bin/fuzzel --dmenu
      '';
    };
  });
}

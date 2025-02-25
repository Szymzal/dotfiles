{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.theme;
in {
  options = {
    mypackages.theme = {
      enable = mkEnableOption "Enable theming";
      prefer-dark-theme = mkOption {
        default = true;
        example = false;
        description = "Prefer dark theme on applications";
        type = types.bool;
      };
      theme = {
        base16-scheme-path = mkOption {
          default = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          example = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
        };
      };
      cursorTheme = {
        xcursor = {
          name = mkOption {
            default = "Catppuccin-Mocha-Dark-Cursors";
            example = "Catppuccin-Mocha-Dark-Cursors";
            description = "Name of xcursor/gtk cursor theme";
            type = types.str;
          };
          package = mkOption {
            default = pkgs.catppuccin-cursors.mochaDark;
            example = literalExpression ''
              pkgs.catppuccin-cursors.mochaDark
            '';
            description = "Package of xcursor/gtk cursor theme";
            type = types.package;
          };
        };
        hyprcursor = {
          name = mkOption {
            default = "Bibata-Modern-Classic-hyprcursor";
            example = "Bibata-Modern-Classic-hyprcursor";
            description = "Name of hyprcursor theme";
            type = types.str;
          };
          package = mkOption {
            default = pkgs.bibata-hyprcursor;
            example = literalExpression ''
              pkgs.bibata-hyprcursor
            '';
            description = "Package of hyprcursor theme";
            type = types.package;
          };
        };
        size = mkOption {
          default = 24;
          example = 48;
          description = "Size of cursor";
          type = types.ints.unsigned;
        };
      };
      iconTheme = {
        name = mkOption {
          default = "Papirus";
          example = "Papirus";
          description = "Name of gtk icon theme";
          type = types.str;
        };
        package = mkOption {
          default = pkgs.papirus-icon-theme;
          example = literalExpression ''
            pkgs.papirus-icon-theme
          '';
          description = "Package of gtk icon theme";
          type = types.package;
        };
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      stylix = {
        base16Scheme = cfg.theme.base16-scheme-path;

        polarity =
          if cfg.prefer-dark-theme
          then "dark"
          else "light";
        image = config.mypackages.wm.wallpaper-path;
        cursor = {
          inherit (cfg.cursorTheme) size;
          inherit (cfg.cursorTheme.xcursor) name package;
        };
      };

      gtk = {
        enable = true;
        iconTheme = {
          inherit (cfg.iconTheme) name package;
        };
      };

      home.packages = [
        cfg.iconTheme.package
      ];
    };
}

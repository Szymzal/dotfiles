{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.theme;
in
{
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
        name = mkOption {
          default = "Catppuccin-Mocha-Dark-Cursors";
          example = "Catppuccin-Mocha-Dark-Cursors";
          description = "Name of gtk cursor theme";
          type = types.str;
        };
        size = mkOption {
          default = 24;
          example = 48;
          description = "Size of cursor";
          type = types.ints.unsigned;
        };
        package = mkOption {
          default = pkgs.catppuccin-cursors.mochaDark;
          example = literalExpression ''
            pkgs.catppuccin-cursors.mochaDark
          '';
          description = "Package of gtk cursor theme";
          type = types.package;
        };
        hyprcursor = {
          enable = mkEnableOption "Enable hyprcursor";
          name = mkOption {
            default = "Bibata-Modern-Classic-hyprcursor";
          };
          package = mkOption {
            default = pkgs.bibata-hyprcursor;
            example = literalExpression ''
              pkgs.bibata-hyprcursor
            '';
            description = "Package for hyprcursor";
            type = types.package;
          };
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

  config = mkIf cfg.enable (let
    hyprcursor-theme = "${cfg.cursorTheme.name}-hyprcursor";
  in
  {
    assertions = [
      {
        assertion = (config.mypackages.wm.enable);
        message = "Enable Window Manager to get wallpaper";
      }
    ];

    stylix.base16Scheme = cfg.theme.base16-scheme-path;

    stylix.polarity = if (cfg.prefer-dark-theme) then "dark" else "light";
    stylix.image = config.mypackages.wm.wallpaper-path;
    stylix.cursor = {
      name = cfg.cursorTheme.name;
      size = cfg.cursorTheme.size;
      package = cfg.cursorTheme.package;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = cfg.iconTheme.name;
        package = cfg.iconTheme.package;
      };
    };

    home.packages = [
      cfg.iconTheme.package
    ];

    home.file.".icons/${hyprcursor-theme}".source = mkIf cfg.cursorTheme.hyprcursor.enable "${cfg.cursorTheme.hyprcursor.package}/share/icons/${hyprcursor-theme}";
    xdg.dataFile."icons/${hyprcursor-theme}".source = mkIf cfg.cursorTheme.hyprcursor.enable "${cfg.cursorTheme.hyprcursor.package}/share/icons/${hyprcursor-theme}";
  });
}

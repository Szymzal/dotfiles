{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.gtk;
in
{
  options = {
    mypackages.gtk = {
      enable = mkEnableOption "Enable gtk";
      prefer-dark-theme = mkOption {
        default = true;
        example = false;
        description = "Prefer dark theme for applications";
        type = types.bool;
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

  config = mkIf cfg.enable {
    environment.systemPackages = [
      cfg.iconTheme.package
      cfg.cursorTheme.package
    ];
  };
}

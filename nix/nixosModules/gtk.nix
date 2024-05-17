{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.gtk;

  toGtk3Ini = generators.toINI {
    mkKeyValue = key: value:
      let value' = if isBool value then boolToString value else toString value;
      in "${escape [ "=" ] key}=${value'}";
  };

  formatGtk2Option = n: v:
    let
      v' = if isBool v then
        boolToString v
      else if isString v then
        ''"${v}"''
      else
        toString v;
    in "${escape [ "=" ] n} = ${v'}";
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
      theme = {
        name = mkOption {
          default = "Catppuccin-Mocha-Standard-Blue-Dark";
          example = "Catppuccin-Mocha-Standard-Blue-Dark";
          description = "Name of gtk theme";
          type = types.str;
        };
        package = mkOption {
          default = pkgs.catppuccin-gtk;
          example = literalExpression ''
            pkgs.catppuccin-gtk
          '';
          description = "Package of gtk theme";
          type = types.package;
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
    mypackages.impermanence.directories = [
      "/etc/xdg/gtk-2.0"
      "/etc/xdg/gtk-3.0"
      "/etc/xdg/gtk-4.0"
    ];

    environment.systemPackages = with pkgs; [
      xdg-desktop-portal-gtk
      cfg.cursorTheme.package
      cfg.iconTheme.package
      cfg.theme.package
    ];

    environment.etc = let
      shareThemes = "${cfg.theme.package}/share/themes/${cfg.theme.name}";
      gtkIni = {
        gtk-application-prefer-dark-theme = cfg.prefer-dark-theme;
      } // optionalAttrs (cfg.theme.name != null) {
        gtk-theme-name = cfg.theme.name;
      } // optionalAttrs (cfg.cursorTheme.name != null) {
        gtk-cursor-theme-name = cfg.cursorTheme.name;
        gtk-cursor-theme-size = cfg.cursorTheme.size;
      } // optionalAttrs (cfg.iconTheme.name != null) {
        gtk-icon-theme-name = cfg.iconTheme.name;
      };
    in
    {
      "xdg/gtk-2.0/gtkrc".text =
        concatMapStrings (line: line + "\n") (mapAttrsToList formatGtk2Option gtkIni);

      "xdg/gtk-3.0/settings.ini".text = toGtk3Ini {
        Settings = gtkIni;
      };

      "xdg/gtk-4.0/settings.ini".text = toGtk3Ini {
        Settings = gtkIni;
      };

      "xdg/gtk-4.0/gtk.css".text = ''
        @import url("file://${shareThemes}/gtk-4.0/gtk.css");
      '';

      "xdg/gtk-4.0/gtk-dark.css".source = "${shareThemes}/gtk-4.0/gtk-dark.css";
      "xdg/gtk-4.0/assets".source = "${shareThemes}/gtk-4.0/assets";
    };
  };
}

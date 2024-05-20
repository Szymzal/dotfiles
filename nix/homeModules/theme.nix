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
        # name = mkOption {
        #   default = "Catppuccin-Mocha-Standard-Blue-Dark";
        #   example = "Catppuccin-Mocha-Standard-Blue-Dark";
        #   description = "Name of gtk theme";
        #   type = types.str;
        # };
        # package = mkOption {
        #   default = pkgs.catppuccin-gtk;
        #   example = literalExpression ''
        #     pkgs.catppuccin-gtk
        #   '';
        #   description = "Package of gtk theme";
        #   type = types.package;
        # };
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
    # qt = {
    #   enable = true;
    #   platformTheme.name = "gtk3";
    # };

    gtk = {
      enable = true;
    #   gtk2.extraConfig = optionalString (cfg.prefer-dark-theme) "gtk-application-prefer-dark-theme=${builtins.toString cfg.prefer-dark-theme}\n";
    #   gtk3.extraConfig = optionalAttrs (cfg.prefer-dark-theme) {
    #     gtk-application-prefer-dark-theme = cfg.prefer-dark-theme;
    #   };
    #   gtk4.extraConfig = optionalAttrs (cfg.prefer-dark-theme) {
    #     gtk-application-prefer-dark-theme = cfg.prefer-dark-theme;
    #   };
    #   theme = {
    #     name = cfg.theme.name;
    #     package = cfg.theme.package;
    #   };
    #   cursorTheme = {
    #     name = cfg.cursorTheme.name;
    #     package = cfg.cursorTheme.package;
    #     size = cfg.cursorTheme.size;
    #   };
      iconTheme = {
        name = cfg.iconTheme.name;
        package = cfg.iconTheme.package;
      };
    };

    home.packages = [
      # cfg.theme.package
      # cfg.cursorTheme.package
      cfg.iconTheme.package
    ];
    #
    # xdg.configFile =
    #   let
    #     gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
    #   in
    #   {
    #     "gtk-4.0/assets".source = "${gtk4Dir}/assets";
    #     "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
    #   };
  };
}

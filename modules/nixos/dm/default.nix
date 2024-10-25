{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  # myLib = config.lib.myLib;
  cfg = config.mypackages.dm;
in {
  options = {
    mypackages.dm = {
      enable = mkEnableOption "Enable Display Manager";
      wallpaper-path = mkOption {
        default = null;
        example = literalExpression ''
          /persist/nixos/wallpaper.png
        '';
        description = "Path to wallpaper (support for: png, jpg, jpeg, webp)";
        type = types.nullOr types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    mypackages.wm.enable = mkForce true;

    services.displayManager.sessionPackages = [
      (config.programs.river.package)
    ];

    services.xserver = {
      enable = true;
      xkb.layout = "pl";
    };

    services.greetd = let
      configFile = pkgs.writeShellScript "init-river-script" (''
          export XDG_SESSION_TYPE="wayland"
          export NIXOS_OZONE_WL="1"
          export XDG_CURRENT_DESKTOP="river"
        ''
        + optionalString (config.mypackages.nvidia.enable && !config.mypackages.nvidia.open.enable) ''
          export LIBVA_DRIVER_NAME="nvidia"
        ''
        + optionalString (config.mypackages.nvidia.enable && config.mypackages.nvidia.open.enable) ''
          export WLR_NO_HARDWARE_CURSORS="1"
        ''
        + ''
          riverctl keyboard-layout pl
          riverctl xcursor-theme ${config.mypackages.theme.cursorTheme.name} ${builtins.toString config.mypackages.theme.cursorTheme.size}

          riverctl spawn "${config.programs.regreet.package}/bin/regreet; riverctl exit"
          riverctl spawn ${pkgs.foot}
        '');
    in {
      enable = true;
      settings.default_session.command = "${config.programs.river.package}/bin/river -c ${configFile} -log-level debug > /var/log/river.log 2>&1";
    };

    mypackages.way-displays.enable = mkDefault true;

    programs.regreet = let
      theme = config.mypackages.theme;
    in {
      enable = true;
      package = pkgs.greetd.regreet.overrideAttrs (oldAttrs: {
        name = "regreet-patched";
        patches =
          oldAttrs.patches
          ++ [./cursor_size.patch];
      });
      iconTheme = {
        name = theme.iconTheme.name;
        package = theme.iconTheme.package;
      };
      cursorTheme = {
        name = theme.cursorTheme.name;
        package = mkForce theme.cursorTheme.package;
      };
      # copied (https://github.com/danth/stylix/blob/master/modules/gtk/hm.nix#L46)
      theme = {
        name = "adw-gtk3";
      };
      settings = {
        background = mkIf (!(isNull cfg.wallpaper-path)) {
          path = cfg.wallpaper-path;
        };
        GTK = {
          application_prefer_dark_theme = theme.prefer-dark-theme;
          cursor_theme_size = theme.cursorTheme.size;
        };
      };
    };
  };
}

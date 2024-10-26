{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
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
      initScript = pkgs.writeShellScript "init-greetd-script" (
        optionalString (config.mypackages.monitors != {} && config.mypackages.monitors.config != []) (let
          primaryMonitor = config.lib.myLib.getPrimaryMonitor;
        in ''
          ${pkgs.wlr-randr}/bin/wlr-randr --output ${primaryMonitor.connector} --on --mode ${builtins.toString primaryMonitor.mode.width}x${builtins.toString primaryMonitor.mode.height}@${builtins.toString primaryMonitor.mode.rate}
        '')
        + ''
          ${config.programs.regreet.package}/bin/regreet
        ''
      );
    in {
      enable = true;
      settings.default_session.command = "${pkgs.cage}/bin/cage -s -m last -- sh -c ${initScript}";
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
          path = mkForce cfg.wallpaper-path;
        };
        GTK = {
          application_prefer_dark_theme = theme.prefer-dark-theme;
          cursor_theme_size = theme.cursorTheme.size;
        };
      };
    };
  };
}

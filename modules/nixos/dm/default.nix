{ pkgs, lib, config, ... }:
with lib;
let
  myLib = config.lib.myLib;
  cfg = config.mypackages.dm;
in
{
  options = {
    mypackages.dm = {
      enable = mkEnableOption "Enable Display Manager";
      wallpaper-path = mkOption {
        default = null;
        example = literalExpression ''
          /persist/nixos/wallpaper.png
        '';
        description = "Path to wallpaper (support for: png, jpg, jpeg, webp)";
        type = types.path;
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

    services.greetd =
    let
      cursors = if (config.mypackages.nvidia.enable && config.mypackages.nvidia.open.enable) then ''
        cursor {
          default_monitor=${myLib.getPrimaryMonitor.connector}
          no_hardware_cursors=true
        }
        env = WLR_NO_HARDWARE_CURSORS,1

      '' else ''
        cursor {
          default_monitor=${myLib.getPrimaryMonitor.connector}
        }
      '';

      hyprcursor = if (config.mypackages.theme.cursorTheme.hyprcursor.enable) then ''
        exec-once=hyprctl setcursor ${config.mypackages.theme.cursorTheme.hyprcursor.name} ${builtins.toString config.mypackages.theme.cursorTheme.size}
        env = HYPRCURSOR_THEME,${config.mypackages.theme.cursorTheme.hyprcursor.name}
        env = HYPRCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}
      '' else "";

      monitors = (lib.concatStrings (lib.forEach (myLib.hyprlandMonitorsConfig) (value:
        "monitor=${value}\n"
      )));

      configFile = pkgs.writeText "hyprland.conf" ''
        input {
          kb_layout=pl
        }
        misc {
          disable_hyprland_logo=true
          disable_splash_rendering=true
        }
        ${cursors}
        ${monitors}
        workspace=1,monitor:${myLib.getPrimaryMonitor.connector},default:true
        windowrulev2=workspace 1,title:(.*)
        ${hyprcursor}
        env = XCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}
        env = XCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}
        exec-once=${config.programs.regreet.package}/bin/regreet; hyprctl dispatch exit
      '';
    in
    {
      enable = true;
      settings.default_session.command = "${config.programs.hyprland.package}/bin/Hyprland --config ${configFile}";
    };

    programs.regreet = (let
      theme = config.mypackages.theme;
    in {
      enable = true;
      package = pkgs.greetd.regreet.overrideAttrs (oldAttrs: {
        name = "regreet-patched";
        patches = oldAttrs.patches
          ++ [ ./cursor_size.patch ];
      });
      font.name = mkIf (config.mypackages.fonts.enable) "FiraCode Nerd Font";
      iconTheme = {
        name = theme.iconTheme.name;
        package = theme.iconTheme.package;
      };
      cursorTheme = {
        name = theme.cursorTheme.name;
        package = theme.cursorTheme.package;
      };
      # copied (https://github.com/danth/stylix/blob/master/modules/gtk/hm.nix#L46)
      theme.name = "adw-gtk3";
      settings = {
        background = mkIf (!(isNull cfg.wallpaper-path)) {
          path = cfg.wallpaper-path;
        };
        GTK = {
          application_prefer_dark_theme = theme.prefer-dark-theme;
          cursor_theme_size = theme.cursorTheme.size;
        };
      };
    });
  };
}

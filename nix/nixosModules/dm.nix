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
        example = "/persist/nixos/wallpaper.png";
        description = "Path to wallpaper (support for: png, jpg, jpeg, webp)";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    mypackages.wm.enable = mkForce true;

    services.xserver = {
      enable = true;
      xkb.layout = "pl";
    };

    services.greetd =
    let
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
        ${monitors}
        workspace=1,monitor:${myLib.getPrimaryMonitor.connector},default:true
        windowrulev2=workspace 1,title:(.*)
        exec-once=hyprctl dispatch workspace 1
        env = HYPRCURSOR_THEME,Catppuccin-Mocha-Dark-Cursors
        env = HYPRCURSOR_SIZE,24
        exec-once=${config.programs.regreet.package}/bin/regreet; hyprctl dispatch exit
      '';
    in
    {
      enable = true;
      settings.default_session.command = "${config.programs.hyprland.package}/bin/Hyprland --config ${configFile}";
    };

    programs.regreet = {
      enable = true;
      settings = {
        background = mkIf (!(isNull cfg.wallpaper-path)) {
          path = cfg.wallpaper-path;
        };
        GTK = mkIf (config.mypackages.gtk.enable) (let
          gtk = config.mypackages.gtk;
        in {
          application_prefer_dark_theme = gtk.prefer-dark-theme;
          cursor_theme_name = gtk.cursorTheme.name;
          cursor_theme_size = gtk.cursorTheme.size;
          theme_size = gtk.theme.name;
        });
      };
    };
  };
}

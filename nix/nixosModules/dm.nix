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
        env = XCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}
        env = XCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}
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
        GTK = (let
          theme = config.mypackages.theme;
        in {
          application_prefer_dark_theme = theme.prefer-dark-theme;
          cursor_theme_name = theme.cursorTheme.name;
          icon_theme_name = theme.iconTheme.name;
          font_name = mkIf (config.mypackages.fonts.enable) "FiraCode Nerd Font";
          # copied (https://github.com/danth/stylix/blob/master/modules/gtk/hm.nix#L46)
          theme_name = "adw-gtk3";
        });
        # GTK = mkIf (config.mypackages.gtk.enable) (let
        #   gtk = config.mypackages.gtk;
        # in {
        #   application_prefer_dark_theme = gtk.prefer-dark-theme;
        #   cursor_theme_name = gtk.cursorTheme.name;
        #   # TODO: Why there is no cursor theme size?
        #   # cursor_theme_size = gtk.cursorTheme.size;
        #   theme_name = gtk.theme.name;
        # });
      };
    };
  };
}

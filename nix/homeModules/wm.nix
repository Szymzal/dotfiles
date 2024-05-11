{ inputs, pkgs, lib, config, osConfig, ... }:
with lib;
let
  myLib = osConfig.lib.myLib;
  cfg = config.mypackages.wm;
in
{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  options = {
    mypackages.wm = {
      enable = mkEnableOption "Enable window manager";
      wallpaper-path = mkOption {
        default = null;
        example = "/persist/nixos/wallpaper.png";
        description = "Path to wallpaper (support for: png, jpg, jpeg, webp)";
        type = types.str;
      };
      splash = mkOption {
        default = false;
        example = "true";
        description = "Enable splashes on screens";
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable
  (let
    power-menu-script = pkgs.writeShellScriptBin "power-menu" ''
      killall wlogout || ${pkgs.wlogout}/bin/wlogout
    '';
    screenshot-script = pkgs.writeShellScriptBin "screenshot" ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -o -r -c '#ff0000ff')" - | ${pkgs.satty}/bin/satty --filename - --fullscreen --output-filename ~/${config.mypackages.screenshot.savePicturesPath}/$(date '+%Y%m%d-%H:%M:%S').png
    '';
    monitors = osConfig.mypackages.monitors;
  in
  {
    assertions = [
      {
        assertion = ((builtins.head monitors) != []);
        message = "Please specify mypackages.monitors in nixos configuration!";
      }
    ];

    mypackages.terminal.enable = mkDefault true;
    mypackages.status-bar.enable = mkDefault true;
    mypackages.launcher.enable = mkDefault true;
    mypackages.notifications.enable = mkDefault true;

    home.packages = with pkgs; [
      killall
      pamixer
      hyprpaper
      wlogout
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        exec-once = [
          "hyprctl dispatch workspace 1"
          "hyprpaper"
          "waybar"
        ];

        input = {
          kb_layout = "pl";
        };

        misc = {
          disable_hyprland_logo = true;
          layers_hog_keyboard_focus = true;
          mouse_move_focuses_monitor = true;
        };

        "$terminal" = "kitty";
        "$mod" = "SUPER";

        env = [
          "XDG_SESSION_TYPE,wayland"
          # TODO: fix
          # Hyprcursor doesn't work for now on NixOS :(
          # "HYPRCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}"
          # "HYPRCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}"
          "XCURSOR_THEME,${config.mypackages.theme.cursorTheme.name}"
          "XCURSOR_SIZE,${builtins.toString config.mypackages.theme.cursorTheme.size}"
        ] ++ lib.optionals osConfig.mypackages.nvidia.enable [
          "LIBVA_DRIVER_NAME,nvidia"
        ] ++ lib.optionals config.mypackages.browser.enable [
          "MOZ_ENABLE_WAYLAND,1"
        ];

        monitor = (myLib.hyprlandMonitorsConfig);
        workspace = [
          "1,monitor:${myLib.getPrimaryMonitor.connector},default:true"
        ];

        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, C, killactive"
          "$mod, M, exit"
          "$mod, Space, togglefloating"

          "$mod, F, fullscreen"
          "$mod, D, exec, killall rofi || rofi -show drun"
          "$mod, Q, exec, ${power-menu-script}/bin/power-menu"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod SHIFT, H, swapwindow, l"
          "$mod SHIFT, L, swapwindow, r"

          "$mod, S, swapactiveworkspaces, DP-1 HDMI-A-1"

          ",XF86AudioRaiseVolume, exec, pamixer -i 2"
          ",XF86AudioLowerVolume, exec, pamixer -d 2"
          ",XF86AudioMute, exec, pamixer -t"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
        ] ++ optionals (config.mypackages.screenshot.enable) [
          "$mod, P, exec, ${screenshot-script}/bin/screenshot"
        ] ++ optionals (config.mypackages.browser.enable) [
          "$mod, B, exec, ${config.programs.firefox.package}/bin/firefox"
        ];

        bindm = [
          # Move/Resize windows with mod + LMB/RMB
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };

    home.file.".config/hypr/hyprpaper.conf".text =
    let
      monitorsConfig = (lib.concatStrings (lib.forEach (monitors) (value:
        if (value.enable) then
          "wallpaper = ${value.connector},${cfg.wallpaper-path}\n"
        else
          ""
      )));
    in
    ''
      preload = ${cfg.wallpaper-path}
      ${monitorsConfig}
      splash = ${trivial.boolToString cfg.splash}
    '';
  });
}

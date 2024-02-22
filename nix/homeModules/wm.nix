{ inputs, pkgs, ... }: 
let
  inherit (inputs) self;
  script = pkgs.writeShellScriptBin "power-menu" ''
    killall rofi || ${pkgs.rofi}/bin/rofi -show power-menu -theme-str 'window {width: 8em;} listview {lines:6;}' -modi power-menu:rofi-power-menu
  '';
in
{
  imports = [
    self.homeModules.statusBar
    self.homeModules.launcher
    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    killall
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = [
        "waybar"
      ];

      input = {
        kb_layout = "pl";
      };

      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };

      "$terminal" = "kitty";
      "$mod" = "SUPER";

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      monitor = [
        "DP-1,1920x1080@144,0x0,1"
        "HDMI-A-1,1920x1080@144,1920x0,1"
      ];

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, Space, togglefloating"

        "$mod, F, fullscreen"
        "$mod, D, exec, killall rofi || rofi -show drun"
        "$mod, Q, exec, ${script}/bin/power-menu"

        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"

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
      ];

      bindm = [
        # Move/Resize windows with mod + LMB/RMB
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}

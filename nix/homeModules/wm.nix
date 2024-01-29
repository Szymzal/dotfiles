{ inputs, ... }: {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
      };

      bindm = [
        "$mod, Return, exec, kitty"
      ];
    };
  };
}

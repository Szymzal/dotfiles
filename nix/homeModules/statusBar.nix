{ ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [ ];
        modules-right = [
          "pulseaudio"
          "temperature"
          "clock"
        ];
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: FiraCode;
      }

      window#waybar {
        background: #16191C;
        color: #AAB2BF;
      }

      #workspaces button {
        padding: 0 5px;
        color: white;
      }
    '';
  };
}

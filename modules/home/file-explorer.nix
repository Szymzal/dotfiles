{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.file-explorer;
in {
  options = {
    mypackages.file-explorer = {
      enable = mkEnableOption "Enable file explorer";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      file-roller
    ];

    programs.nnn = {
      enable = true;
      extraPackages = with pkgs; [
        util-linux
        pmount
      ];
      plugins = {
        # src =
        #   (pkgs.fetchFromGitHub {
        #     owner = "jarun";
        #     repo = "nnn";
        #     rev = "v5.1";
        #     sha256 = "";
        #   })
        #   + "/plugins";
      };
    };

    mypackages.impermanence = {
      directories = [
        ".config/gtk-3.0/bookmarks"
        ".config/Thunar"
        ".config/xfce4"
      ];
    };

    home.file = {
      ".config/xfce4/helpers.rc".text = ''
        TerminalEmulator=${lib.getExe pkgs.foot}
      '';
    };
  };
}

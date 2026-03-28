{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    environment = {
      systemPackages = [
        pkgs.bibata-cursors
      ];
      sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        LIBVA_DRIVER_NAME = "nvidia";

        NVD_BACKEND = "direct";
      };
    };
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        prefer-no-csd = null;

        input = {
          focus-follows-mouse = null;

          keyboard = {
            xkb.layout = "pl";
            repeat-rate = 40;
            repeat-delay = 250;
          };
        };

        cursor = {
          xcursor-theme = "Bibata-Modern-Classic";
          xcursor-size = 16;
        };

        layout = {
          gaps = 5;
          focus-ring = {
            width = 2;
          };
        };

        hotkey-overlay = {
          skip-at-startup = null;
          hide-not-bound = null;
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.foot;

          "Mod+Q".close-window = null;
          "Mod+F".fullscreen-window = null;
          "Mod+G".maximize-column = null;
          "Mod+Space".toggle-window-floating = null;
          "Mod+C".center-column = null;

          "Mod+H".focus-column-left = null;
          "Mod+L".focus-column-right = null;
          "Mod+K".focus-window-up = null;
          "Mod+J".focus-window-down = null;

          "Mod+Left".move-workspace-to-monitor-left = null;
          "Mod+Right".move-workspace-to-monitor-right = null;
          "Mod+Up".move-workspace-to-monitor-up = null;
          "Mod+Down".move-workspace-to-monitor-down = null;

          "Mod+Shift+H".move-column-left = null;
          "Mod+Shift+L".move-column-right = null;
          "Mod+Shift+K".move-window-up = null;
          "Mod+Shift+J".move-window-down = null;

          "Mod+1".focus-workspace = "w0";
          "Mod+2".focus-workspace = "w1";
          "Mod+3".focus-workspace = "w2";
          "Mod+4".focus-workspace = "w3";
          "Mod+5".focus-workspace = "w4";
          "Mod+6".focus-workspace = "w5";
          "Mod+7".focus-workspace = "w6";
          "Mod+8".focus-workspace = "w7";
          "Mod+9".focus-workspace = "w8";
          "Mod+0".focus-workspace = "w9";

          "Mod+Shift+1".move-column-to-workspace = "w0";
          "Mod+Shift+2".move-column-to-workspace = "w1";
          "Mod+Shift+3".move-column-to-workspace = "w2";
          "Mod+Shift+4".move-column-to-workspace = "w3";
          "Mod+Shift+5".move-column-to-workspace = "w4";
          "Mod+Shift+6".move-column-to-workspace = "w5";
          "Mod+Shift+7".move-column-to-workspace = "w6";
          "Mod+Shift+8".move-column-to-workspace = "w7";
          "Mod+Shift+9".move-column-to-workspace = "w8";
          "Mod+Shift+0".move-column-to-workspace = "w9";

          "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe pkgs.pamixer} -i 2";
          "XF86AudioLowerVolume".spawn-sh = "${lib.getExe pkgs.pamixer} -d 2";
          "XF86AudioMute".spawn-sh = "${lib.getExe pkgs.pamixer} -t";

          "Mod+Ctrl+H".set-column-width = "-5%";
          "Mod+Ctrl+L".set-column-width = "+5%";
          "Mod+Ctrl+J".set-window-height = "-5%";
          "Mod+Ctrl+K".set-window-height = "+5%";

          "Mod+Z".spawn-sh = self.mkWhichKeyExe pkgs [
            {
              key = "b";
              desc = "Browser";
              cmd = "zen-beta";
            }
            {
              key = "f";
              desc = "File Explorer";
              cmd = "thunar";
            }
            {
              key = "t";
              desc = "Process Manager";
              cmd = "btop";
            }
            {
              key = "s";
              desc = "Pavucontrol";
              cmd = "${lib.getExe pkgs.pavucontrol}";
            }
          ];
        };

        outputs = {
          DP-1 = {
            mode = "1920x1080@144.001";
            "position x=0 y=0" = null;
          };
          HDMI-A-1 = {
            mode = "1920x1080@143.998";
            "position x=1920 y=0" = null;
          };
        };

        animations = {off = null;};

        spawn-at-startup = [
          (lib.getExe (
            pkgs.writeShellScriptBin "wallpaper"
            "${lib.getExe pkgs.swaybg} -i ${pkgs.fetchurl {
              name = "wallpaper";
              url = "https://raw.githubusercontent.com/DenverCoder1/minimalistic-wallpaper-collection/main/images/dalle2-minimalistic-colorful-flat-mountain-landscape.png";
              hash = "sha256-ON54b7rzocXoFXKQmfAuG4xXaC2AUH1r1x6m4YqnNIs=";
            }} -m fill"
          ))
          (lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia)
        ];
      };
    };
  };
}

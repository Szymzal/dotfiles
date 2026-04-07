{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {pkgs, ...}: {
    imports = [
      self.nixosModules.noctalia
    ];

    security.polkit.enable = true;
    programs = {
      niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        useNautilus = true;
      };
      xwayland.enable = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
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

          "Mod+Ctrl+H".focus-monitor-left = null;
          "Mod+Ctrl+L".focus-monitor-right = null;
          "Mod+Ctrl+K".focus-monitor-up = null;
          "Mod+Ctrl+J".focus-monitor-down = null;

          "Mod+1".focus-workspace-up = null;
          "Mod+2".focus-workspace-down = null;

          "XF86AudioRaiseVolume".spawn-sh = "${lib.getExe pkgs.pamixer} -i 2";
          "XF86AudioLowerVolume".spawn-sh = "${lib.getExe pkgs.pamixer} -d 2";
          "XF86AudioMute".spawn-sh = "${lib.getExe pkgs.pamixer} -t";

          "Mod+Minus".set-column-width = "-5%";
          "Mod+Equal".set-column-width = "+5%";
          "Mod+Shift+Minus".set-window-height = "-5%";
          "Mod+Shift+Equal".set-window-height = "+5%";

          "Mod+D".spawn-sh = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia} ipc call launcher toggle";
          "Mod+O".spawn-sh = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia} ipc call sessionMenu toggle";
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
            position = _: {
              props = {
                x = 0;
                y = 0;
              };
            };
          };
          HDMI-A-1 = {
            mode = "1920x1080@143.998";
            position = _: {
              props = {
                x = 1920;
                y = 0;
              };
            };
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

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

        prefer-no-csd = _: {};

        input = {
          focus-follows-mouse = _: {};

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
          skip-at-startup = _: {};
          hide-not-bound = _: {};
        };

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.foot;

          "Mod+Q".close-window = _: {};
          "Mod+F".fullscreen-window = _: {};
          "Mod+G".maximize-column = _: {};
          "Mod+Space".toggle-window-floating = _: {};
          "Mod+C".center-column = _: {};

          "Mod+H".focus-column-left = _: {};
          "Mod+L".focus-column-right = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+J".focus-window-down = _: {};

          "Mod+Left".move-workspace-to-monitor-left = _: {};
          "Mod+Right".move-workspace-to-monitor-right = _: {};
          "Mod+Up".move-workspace-to-monitor-up = _: {};
          "Mod+Down".move-workspace-to-monitor-down = _: {};

          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+L".move-column-right = _: {};
          "Mod+Shift+K".move-window-up = _: {};
          "Mod+Shift+J".move-window-down = _: {};

          "Mod+Ctrl+H".focus-monitor-left = _: {};
          "Mod+Ctrl+L".focus-monitor-right = _: {};
          "Mod+Ctrl+K".focus-monitor-up = _: {};
          "Mod+Ctrl+J".focus-monitor-down = _: {};

          "Mod+1".focus-workspace-up = _: {};
          "Mod+2".focus-workspace-down = _: {};

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
            # mode = "1920x1080@143.998";
            mode = "1920x1080@60";
            position = _: {
              props = {
                x = 1920;
                y = 0;
              };
            };
          };
        };

        animations = {off = _: {};};

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

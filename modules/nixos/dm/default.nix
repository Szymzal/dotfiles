{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.dm;
in {
  disabledModules = [
    "${inputs.nixpkgs}/nixos/modules/programs/wayland/uwsm.nix"
  ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/programs/wayland/uwsm.nix"
  ];

  options = {
    mypackages.dm = {
      enable = mkEnableOption "Enable Display Manager";
      wallpaper-path = mkOption {
        default = null;
        example = literalExpression ''
          /persist/nixos/wallpaper.png
        '';
        description = "Path to wallpaper (support for: png, jpg, jpeg, webp)";
        type = types.nullOr types.path;
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      xkb.layout = "pl";
    };

    environment.systemPackages = with pkgs; [
      (catppuccin-sddm.override
        {
          flavor = "mocha";
          font = "${config.stylix.fonts.sansSerif.name}";
          fontSize = "${toString config.stylix.fonts.sizes.applications}";
        })
    ];

    services.displayManager = {
      enable = true;
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "catppuccin-mocha";
        settings = {
          Theme = {
            CursorTheme = "${config.mypackages.theme.cursorTheme.xcursor.name}";
            CursorSize = config.mypackages.theme.cursorTheme.size;
          };
        };
        wayland = {
          enable = true;
          compositorCommand = let
            xcfg = config.services.xserver;
            westonIni = pkgs.concatText "weston.ini" [
              (builtins.toFile "weston-output" ''
                [output]
                name=HDMI-A-1
                mode=off

                [output]
                name=DP-1
                mode=1920x1080@144
              '')
              ((pkgs.formats.ini {}).generate
                "weston-generic.ini"
                {
                  libinput = {
                    enable-tap = config.services.libinput.mouse.tapping;
                    left-handed = config.services.libinput.mouse.leftHanded;
                  };
                  keyboard = {
                    keymap_model = xcfg.xkb.model;
                    keymap_layout = xcfg.xkb.layout;
                    keymap_variant = xcfg.xkb.variant;
                    keymap_options = xcfg.xkb.options;
                  };
                  shell = {
                    cursor-theme = "${config.mypackages.theme.cursorTheme.xcursor.name}";
                    cursor-size = config.mypackages.theme.cursorTheme.size;
                  };
                })
            ];
          in "${getExe pkgs.weston} --shell kiosk -c ${westonIni}";
        };
      };
    };

    mypackages.impermanence.directories = [
      "/var/lib/sddm"
    ];
  };
}

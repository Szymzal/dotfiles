{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.dm;
in {
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
      defaultSession = "river";
      sddm = {
        enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "catppuccin-mocha";
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
                    cursor-theme = "${config.mypackages.theme.cursorTheme.name}";
                    cursor-size = config.mypackages.theme.cursorTheme.size;
                  };
                })
            ];
          in "${getExe pkgs.weston} --shell kiosk -c ${westonIni}";
        };
      };
      sessionPackages = [
        (config.programs.river.package)
      ];
    };

    # services.greetd = let
    #   initScript = pkgs.writeShellScript "init-greetd-script" (
    #     optionalString (config.mypackages.monitors != {} && config.mypackages.monitors.config != []) (let
    #       primaryMonitor = config.lib.myLib.getPrimaryMonitor;
    #     in ''
    #       ${pkgs.wlr-randr}/bin/wlr-randr --output ${primaryMonitor.connector} --on --mode ${builtins.toString primaryMonitor.mode.width}x${builtins.toString primaryMonitor.mode.height}@${builtins.toString primaryMonitor.mode.rate}
    #     '')
    #     + ''
    #       ${config.programs.regreet.package}/bin/regreet
    #     ''
    #   );
    # in {
    #   enable = true;
    #   settings.default_session.command = "${pkgs.cage}/bin/cage -s -m last -- sh -c ${initScript}";
    # };
    #
    # programs.regreet = let
    #   theme = config.mypackages.theme;
    # in {
    #   enable = true;
    #   package = pkgs.greetd.regreet.overrideAttrs (oldAttrs: {
    #     name = "regreet-patched";
    #     patches =
    #       oldAttrs.patches
    #       ++ [./cursor_size.patch];
    #   });
    #   iconTheme = {
    #     name = theme.iconTheme.name;
    #     package = theme.iconTheme.package;
    #   };
    #   cursorTheme = {
    #     name = theme.cursorTheme.name;
    #     package = mkForce theme.cursorTheme.package;
    #   };
    #   # copied (https://github.com/danth/stylix/blob/master/modules/gtk/hm.nix#L46)
    #   theme = {
    #     name = "adw-gtk3";
    #   };
    #   settings = {
    #     background = mkIf (!(isNull cfg.wallpaper-path)) {
    #       path = mkForce cfg.wallpaper-path;
    #     };
    #     GTK = {
    #       application_prefer_dark_theme = theme.prefer-dark-theme;
    #       cursor_theme_size = theme.cursorTheme.size;
    #     };
    #   };
    # };
  };
}

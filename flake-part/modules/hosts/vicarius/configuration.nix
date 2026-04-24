{
  self,
  pkgs,
  ...
}: {
  flake.nixosModules.machineConfiguration = {...}: {
    imports = [
      self.nixosModules.options
      self.nixosModules.vicuriusHardware
      self.nixosModules.niri
      self.nixosModules.neovim
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.dbus.implementation = "broker";

    boot.plymouth.enable = true;

    nixpkgs.config.allowUnfree = true;

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "pl_PL.UTF-8";
      };
    };

    services = {
      desktopManger.plasma6.enable = true;
      tailscale = {
        enable = true;
        openFirewall = true;
      };
    };

    environment.systemPackages = with pkgs; [
      foot
      git
      chromium
      ffmpeg
      btop
      tmux
    ];
  };
}

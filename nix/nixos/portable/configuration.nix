{ inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    ./hardware-configuration.nix
    self.nixosModules.modules
  ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = false;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_6_10;

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  console = {
    keyMap = "pl";
  };

  time.timeZone = "Europe/Warsaw";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
  ];

  networking = {
    firewall.enable = true;
    nftables.enable = true;
  };

  environment.systemPackages = with pkgs; [
    btop
  ];

  mypackages = {
    ssh.enable = true;
    networkmanager = {
      enable = true;
      hostName = "portable-camera";
    };
    gc.enable = true;
    editor.enable = true;
    clipboard.enable = true;
    git.enable = true;
    multiTerminal.enable = true;
    cachix.enable = true;

    # monitors = [
    #   {
    #     enable = true;
    #     primary = true;
    #     connector = "DP-1";
    #     position = {
    #       x = 0;
    #       y = 0;
    #     };
    #     mode = {
    #       width = 1920;
    #       height = 1080;
    #       rate = 144.00101;
    #       scale = 1.0;
    #     };
    #   }
    #   {
    #     enable = true;
    #     connector = "HDMI-A-1";
    #     position = {
    #       x = 1920;
    #       y = 0;
    #     };
    #     mode = {
    #       width = 1920;
    #       height = 1080;
    #       rate = 143.99800;
    #       scale = 1.0;
    #     };
    #   }
    # ];

    sound.enable = true;
    fonts.enable = true;
    shell.enable = true;
    wm.enable = true;
    dm = {
      enable = true;
      wallpaper-path = /persist/customization/wallpaper.jpg;
    };
    home-manager.enable = true;
    compression.enable = true;
    nix-helpers.enable = true;
  };

  myusers.camera.enable = true;
}

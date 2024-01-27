{ inputs, pkgs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    ./hardware-configuration.nix
    # Desktop always needs to be before common
    # for whatever reason
    self.nixosModules.desktop
    self.nixosModules.common

    ../../../users/szymzal
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/shared" = {
    fsType = "vboxsf";
    device = "boxshared";
    options = [ "rw" "nofail" ];
  };

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "pl";
  };

  # TODO: Is that really needed?
  # Would it not be enough for only in common.nix?
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}

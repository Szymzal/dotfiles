{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.casparcg;
in {
  options = {
    mypackages.casparcg = {
      enable = mkEnableOption "Enable CasparCG";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      casparcg-server
      casparcg-media-scanner
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "freeimage-3.18.0-unstable-2024-04-18"
    ];

    # containers = {
    #   casparcg = {
    #     privateNetwork = true;
    #     hostAddress = "192.168.16.10";
    #     localAddress = "192.168.16.11";
    #     config = {lib, ...}: {
    #       environment.systemPackages = with pkgs; [
    #         casparcg-server
    #       ];
    #
    #       networking = {
    #         # TODO: nftables?
    #         firewall = {
    #           enable = true;
    #         };
    #         useHostResolvConf = lib.mkForce false;
    #       };
    #
    #       system.stateVersion = "24.05";
    #     };
    #   };
    # };
  };
}

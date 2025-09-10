{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.tailscale;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in {
  options = {
    mypackages.tailscale = {
      enable = mkEnableOption "Enable tailscale VPN";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      package = pkgs-unstable.tailscale;
    };

    mypackages.impermanence.directories = [
      {
        directory = "/var/lib/tailscale";
        mode = "0700";
      }
    ];
  };
}

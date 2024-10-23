{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.tailscale;
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
    };

    mypackages.impermanence.directories = [
      {
        directory = "/var/lib/tailscale";
        mode = "0700";
      }
    ];
  };
}

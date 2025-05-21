{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.network;
in {
  options = {
    mypackages.network = {
      enable = mkEnableOption "Enable Network";
      hostName = mkOption {
        default = "pc";
        example = "homePC";
        description = "Computer name on local network";
        type = types.str;
      };
      wireless = mkOption {
        default = false;
        example = true;
        description = "Enable wireless";
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      firewall.enable = true;
      nftables.enable = true;
      useNetworkd = true;
      wireless.iwd = {
        enable = cfg.wireless;
        settings = {
          Settings = {
            AutoConnect = true;
          };
        };
      };
    };

    systemd.network = {
      enable = true;
      wait-online.enable = false;
      # TODO: Make it declarable
      networks = let
        networkConfig = {
          DHCP = "yes";
        };
      in {
        "40-wired" = {
          enable = true;
          name = "en*";
          inherit networkConfig;
        };
      };
    };
  };
}

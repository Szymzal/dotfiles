{ config, lib, ... }:
with lib;
let
  cfg = config.mypackages.ssh;
in
{
  options = {
    mypackages.ssh = {
      enable = mkEnableOption "Enable ssh server";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    mypackages.impermanence.files = [
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}

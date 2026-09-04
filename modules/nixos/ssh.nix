{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mypackages.ssh;
in {
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

    mypackages.impermanence.directories = [
      "/etc/ssh"
    ];
  };
}

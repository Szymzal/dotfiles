{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.virtualization;
in {
  options = {
    mypackages.virtualization = {
      enable = mkEnableOption "Enable virtualization";
    };
  };

  config = mkIf (cfg.enable) {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;

    networking.firewall.interfaces = {
      "virb*" = {
        allowedTCPPorts = [53];
        allowedUDPPorts = [53 67];
      };
      "lxdbr*" = {
        allowedTCPPorts = [53];
        allowedUDPPorts = [53 67];
      };
    };
  };
}
{
  lib,
  config,
  pkgs,
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

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = true;

    # TODO: Fix problem with networking
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

    mypackages.impermanence.directories = ["/var/lib/libvirt" "/var/lib/qemu"];
  };
}

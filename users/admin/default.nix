{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myusers.camera;
in {
  options = {
    myusers.camera = {
      enable = mkEnableOption "Enable Camera user";
    };
  };

  config = mkIf cfg.enable {
    mypackages.home-manager.enable = true;

    users.mutableUsers = false;
    users.users.admin = {
      createHome = true;
      extraGroups = ["wheel" "networkmanager"];
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = mkIf config.mypackages.ssh.enable [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE6vaWToYAsNeXoorsn6MBbgMyJ4Iw9MesRKV890NwP szymzal@phone"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRdjf1Bi1C7Vb7uJftM8xr1MwQDZ08MmX3mRq4JiIPB szymzal@machine"
      ];
    };

    home-manager.users.admin = {
      imports = [./home.nix];
    };
  };
}

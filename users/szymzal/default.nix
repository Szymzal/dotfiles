{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myusers.szymzal;
in {
  options = {
    myusers.szymzal = {
      enable = mkEnableOption "Enable Szymzal user";
    };
  };

  config = mkIf cfg.enable {
    mypackages.home-manager.enable = true;

    users.mutableUsers = false;
    users.users.szymzal = {
      createHome = true;
      extraGroups = ["wheel" "networkmanager" "wireshark" "adbusers" "minecraft" "scanner" "lp" "gamemode"];
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = mkIf config.mypackages.ssh.enable [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPE6vaWToYAsNeXoorsn6MBbgMyJ4Iw9MesRKV890NwP szymzal@phone"
      ];
    };

    sops.secrets.password = {
      sopsFile = ../../secrets/secrets.yaml;
      neededForUsers = true;
    };

    systemd.tmpfiles.rules = [
      # Home manager cannot create directory itself
      # Only for the first time
      "d /persist/home/szymzal 0750 szymzal users -"
    ];

    home-manager.users.szymzal = {
      imports = [./home.nix];
    };
  };
}

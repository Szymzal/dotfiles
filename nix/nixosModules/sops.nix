{ inputs, pkgs, lib, config, ... }:
with lib;
let
  cfg = config.mypackages.sops;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    mypackages.sops = {
      enable = mkEnableOption "Enable sops";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];

    # TODO: Make options for this
    sops.defaultSopsFile = ../../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";

    sops.age.keyFile = "/persist/home/szymzal/.config/sops/age/keys.txt";

    sops.secrets.password = { };
    sops.secrets.password.neededForUsers = true;
  };
}

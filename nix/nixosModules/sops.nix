{ inputs, pkgs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = with pkgs; [
    sops
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/persist/home/szymzal/.config/sops/age/keys.txt";

  sops.secrets.password = { };
  sops.secrets.password.neededForUsers = true;
}

{ pkgs, inputs, ... }: {
  imports = [
    inputs.home-manager.nixosModules.default

    ../../packages
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    bash
  ];
}

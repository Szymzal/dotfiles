{inputs, ...}: {
  flake.nixosModules.ollama = {pkgs, ...}: let
    pkgs-unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    services = {
      ollama = {
        enable = true;
        package = pkgs-unstable.ollama.override {
          acceleration = "vulkan";
        };
      };
      open-webui.enable = true;
    };
    persistence.system.directories = [
      {
        directory = "/var/lib/private";
        mode = "u=rwx,g=,o=";
      }
      "/var/lib/private/ollama"
      "/var/lib/private/open-webui"
    ];
  };
}

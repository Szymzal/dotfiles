{
  flake.nixosModules.ollama = {pkgs, ...}: {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama.override {
          acceleration = "vulkan";
        };
      };
      open-webui.enable = true;
    };
  };
}

{
  self,
  inputs,
  ...
}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    packages.browser = inputs.zen-browser.packages."${system}".default;
    packages.fileExplorer = pkgs.thunar;
  };

  flake.nixosModules.desktopApps = {pkgs, ...}: {
    imports = [
      inputs.noctalia-greeter.nixosModules.default
    ];

    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.browser
    ];

    programs = {
      dconf.enable = true;
      thunar = {
        enable = true;
        plugins = with pkgs; [thunar-archive-plugin];
      };
    };

    services = {
      gvfs.enable = true;
      udisks2.enable = true;
      displayManager.noctalia-greeter = {
        enable = true;
        settings = {
          cursor = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            path = "${pkgs.bibata-cursors}/share/icons";
          };
        };
      };
    };
  };
}

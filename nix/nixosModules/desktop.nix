{ pkgs, ... }: {
  home-manager = {
    extraSpecialArgs = {
      isDesktop = true;
    };
  };

  security.polkit.enable = true;

  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };
}

{ inputs, ... }: 
let
  inherit (inputs) self;
in
{
  home-manager = {
    extraSpecialArgs = {
      isDesktop = true;
    };
  };

  imports = [
    self.nixosModules.wm
    self.nixosModules.dm
    self.nixosModules.sound
  ];

  security.polkit.enable = true;

  hardware.opengl = {
    enable = true;
  };

  hardware.xone.enable = true;

  environment.sessionVariables = {
    # discord
    NIXOS_OZONE_WL = "1";
  };
}

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
  ];

  security.polkit.enable = true;

  hardware.opengl = {
    enable = true;
  };
}

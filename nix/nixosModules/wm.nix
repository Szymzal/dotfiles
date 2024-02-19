{ inputs, pkgs, ... }: 
let
  hyprland_package = inputs.hyprland.packages."${pkgs.system}".hyprland;
in
{

  programs.hyprland = {
    enable = true;
    package = hyprland_package;
  };

  # services.xserver = {
  #   displayManager.sessionPackages = [ hyprland_package ];
  # };
}

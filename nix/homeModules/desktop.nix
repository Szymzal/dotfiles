{ lib, config, inputs, ... }:
with lib;
let
  cfg = config.mypackages.desktop;
in
{
  # imports = [
  #   self.homeModules.terminal
  #   self.homeModules.wm
  # ];
}

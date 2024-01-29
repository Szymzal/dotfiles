{ inputs, ... }: 
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.terminal
    self.homeModules.wm
  ];
}

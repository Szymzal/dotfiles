{ inputs, ... }: 
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.wm
  ];
}

{ inputs, ... }: 
let
  inherit (inputs) self;
in
{
  imports = [
    self.homeModules.git
    self.homeModules.tmux
  ];
}

{ pkgs, inputs, ... }:
let
  inherit (inputs) self;
in
{
  imports = [
    inputs.home-manager.nixosModules.default
    self.nixosModules.font
    self.nixosModules.shell
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  environment = {
    systemPackages = with pkgs; [
      git
      bash
      neovim
      tmux
    ];
    variables = {
      EDITOR = "nvim";
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      isDesktop = false;
    };
  };
}

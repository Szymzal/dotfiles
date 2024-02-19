{ pkgs, inputs, ... }: 
let
  inherit (inputs) self;
in
{
  imports = [
    self.nixosModules.font
    self.nixosModules.sops
    self.nixosModules.shell
    inputs.home-manager.nixosModules.default
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    systemPackages = with pkgs; [
      git
      bash
      neovim
      tmux
      wl-clipboard
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

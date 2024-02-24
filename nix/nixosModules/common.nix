{ pkgs, ... }: {
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
}

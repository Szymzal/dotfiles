{ pkgs, ... }: {
  users.users.szymzal = {
    createHome = true;
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  home-manager.users.szymzal = {
    imports = [ ./home.nix ];
  };
}

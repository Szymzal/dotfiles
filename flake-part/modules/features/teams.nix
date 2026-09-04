{
  flake.nixosModules.teams = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      teams-for-linux
    ];
    persistence.user.directories = [
      ".config/teams-for-linux"
    ];
  };
}

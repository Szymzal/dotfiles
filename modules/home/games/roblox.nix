{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.games.roblox;
  flatpakref = pkgs.fetchurl {
    url = "https://sober.vinegarhq.org/sober.flatpakref";
    hash = "sha256-VFRvboQ7IZwYDQvEcWimOuno7vIj+5EztOvxCHvwSN4=";
  };
in
{
  options = {
    mypackages.games.roblox = {
      enable = mkEnableOption "Enable Roblox";
    };
  };

  # APKs:
  # https://www.apkmirror.com/apk/roblox-corporation/roblox/
  config = mkIf cfg.enable {
    mypackages.flatpak = {
      enable = true;
      packages = [ ":${flatpakref}" ];
    };
  };
}

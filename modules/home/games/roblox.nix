{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.games.roblox;
  flatpakref = with pkgs; stdenv.mkDerivation {
    name = "sober-flatpakref";
    src = fetchurl {
      url = "https://sober.vinegarhq.org/sober.flatpakref";
      hash = "sha256-VFRvboQ7IZwYDQvEcWimOuno7vIj+5EztOvxCHvwSN4=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp $src $out/sober.flatpakref

      runHook postInstall
    '';
  };
in
{
  options = {
    mypackages.games.roblox = {
      enable = mkEnableOption "Enable Roblox";
    };
  };

  config = mkIf cfg.enable {
    mypackages.flatpak = {
      enable = true;
      packages = [ ":${flatpakref}/sober.flatpakref" ];
    };
  };
}

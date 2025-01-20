{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.mypackages.epic-games;
in {
  options = {
    mypackages.epic-games = {
      enable = mkEnableOption "Enable Epic Games Store";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      legendary-gl
      (pkgs.writeShellScriptBin "legendary-launch" ''
        json=$(${lib.getExe legendary-gl} launch "$1" --json --no-wine)
        what=$(${lib.getExe pkgs.jq} '(.game_parameters + .egl_parameters + .user_parameters) | join(" ")' <<< "$json")
        game_executable=$(${lib.getExe pkgs.jq} '.game_directory + "/" + .game_executable' <<< "$json")
        run="${lib.getExe' pkgs.bottles "bottles-cli"} run --bottle \"Epic Games Games\" -e '$game_executable' --args $what"
        eval $run
      '')
    ];

    mypackages.bottles.enable = true;

    mypackages.impermanence.directories = [
      ".config/legendary"
    ];
  };
}

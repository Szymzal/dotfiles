{ lib, config, inputs, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.games.rocket-league;
in
{
  options = {
    mypackages.games.rocket-league = {
      enable = mkEnableOption "Enable Rocket League BakkesMod";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gamemode
      inputs.nix-gaming.packages.${pkgs.system}.rocket-league
    ] ++ (inputs.nix-gaming.lib.legendaryBuilder pkgs {});

    # mypackages.steam.enable = true;

    # TODO: BakkesMod some time
    #
    # environment.systemPackages = with pkgs; [
    #   killall
    #   protontricks
    # ];

    # systemd.tmpfiles.rules = 
    # let
    #   bakkesModLaunchScript = pkgs.writeShellScript "bakkes.sh" ''
    #     # WARNING! Steam runs scripts like this with `/bin/sh -c "/path/to/this/script.sh"` and not bash
    #     # sh handles some things differently
    #     # (e.g. spaces in paths -> we have to wrap every path variable with double quotes)
    #
    #     # Set Rocket League launch options to `"/path/to/this/script.sh" & %command%`
    #     # Put any other launch options before `%command%` like normal
    #
    #     # WINEPREFIX for Rocket League
    #     RL_PREFIX="$HOME/.local/share/Steam/steamapps/compatdata/252950"
    #
    #     # This is the default BakkesMod installation path
    #     # Change this if you've installed Bakkes somewhere else
    #     BAKKES="$RL_PREFIX/pfx/drive_c/Program Files/BakkesMod/BakkesMod.exe"
    #
    #     # Use WINEESYNC (E) or WINEFSYNC (F)
    #     # This needs to match the one RocketLeague is launched with
    #     # fsync requires support in the kernel
    #     WINESYNC="F"
    #
    #     # Check that BakkesMod.exe exists
    #     if [[ -f "$BAKKES" ]]; then
    #       echo "1";
    #       # Start BakkesMod when Rocket League starts
    #       # killall -0 sends no signal but still performs error checking
    #       # that way we can detect if a program is running or not
    #       while ! killall -0 RocketLeague.exe 2> /dev/null; do
    #         echo "2";
    #         sleep 1
    #       done
    #       echo "3";
    #
    #       # Open BakkesMod with the correct Proton version and Wine prefix
    #       # Doesn't require protontricks 
    #       if [ $WINESYNC = "E" ]; then
    #         echo "4.1";
    #         echo "IMPORTANT! Running Rocket League with WINEESYNC=1" 
    #         echo "IMPORTANT! If BakkesMod fails to launch, switch to WINEFSYNC=1"
    #         # WINEESYNC=1 WINEPREFIX="$RL_PREFIX/pfx" "$PROTON/bin/wine64" "$BAKKES" &
    #         protontricks -c "WINEESYNC=1 wine $BAKKES" 252950 &
    #         echo "5.1";
    #       else
    #         echo "4.2";
    #         echo "IMPORTANT! Running Rocket League with WINEFSYNC=1" 
    #         echo "IMPORTANT! If BakkesMod fails to launch, switch to WINEESYNC=1"
    #         # WINEFSYNC=1 WINEPREFIX="$RL_PREFIX/pfx" "$PROTON/bin/wine64" "$BAKKES" &
    #         protontricks -c "WINEFSYNC=1 wine $BAKKES" 252950 &
    #         echo "5.2";
    #       fi
    #
    #       echo "6";
    #       # Kill BakkesMod process when Rocket League is closed
    #       while killall -0 RocketLeague.exe 2> /dev/null; do
    #         sleep 1
    #       done
    #       echo "7";
    #       killall BakkesMod.exe
    #     else
    #         echo "$BAKKES doesn't exist! ABORTING!"
    #     fi
    #   '';
    # in
    # [
    #   "L+ /persist/bakkes.sh - - - - ${bakkesModLaunchScript}"
    # ];
  };
}

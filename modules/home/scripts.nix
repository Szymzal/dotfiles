{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.scripts;
in {
  options = {
    mypackages.scripts = {
      enable = mkEnableOption "Enable scripts";
      path = mkOption {
        type = types.str;
        default = "~/dev/*";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.writeShellScriptBin "projects" ''
        DIR=$(find ${cfg.path} -maxdepth 0 | ${getExe pkgs.fzf})
        cd "$DIR" || exit

        ACTUAL_SHELL="$SHELL"
        if [[ -e "$DIR/flake.nix" ]]; then
          read -p "Would you like to go into devshell? [y/N] " -n 1 -r
          echo

          if [[ $REPLY =~ ^[Yy]$ ]]; then
            if [[ -z "$TMUX" ]]; then
              ${getExe pkgs.nix-output-monitor} develop -c ${getExe pkgs.tmux}
            else
              ${getExe pkgs.nix-output-monitor} develop -c "$ACTUAL_SHELL"
            fi
            exit
          fi
        fi

        if [[ -z "$TMUX" ]]; then
          ${getExe pkgs.tmux}
        fi
      '')
    ];
  };
}

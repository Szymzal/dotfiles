{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.terminal;
in {
  options = {
    mypackages.terminal = {
      enable = mkEnableOption "Enable terminal";
    };
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
    };

    home.sessionVariables = {
      TERMINAL = "foot";
      TERM = "foot";
    };

    # systemd.user.services.foot = {
    #   Service = {
    #     ExecStart = mkForce (toString (pkgs.writeShellScript "foot-server" ''
    #       PATH=$PATH:/etc/profiles/per-user/$USER/bin/:$HOME/.nix-profile/bin/:/run/current-system/sw/bin/
    #       ${lib.getExe config.programs.foot.package} --server
    #     ''));
    #   };
    # };

    home = {
      file.".config/xdg-terminals.list".text = ''
        foot.desktop
      '';
      packages = with pkgs; [
        xdg-terminal-exec
      ];
    };
  };
}

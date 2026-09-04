{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.keyring;
in {
  options = {
    mypackages.keyring = {
      enable = mkEnableOption "Enable keyring";
    };
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    environment.systemPackages = with pkgs; [libsecret];
    security.pam.services.sddm.enableGnomeKeyring = true;
    environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";
    programs.seahorse.enable = true;
  };
}

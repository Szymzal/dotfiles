{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.rclone;
in {
  options = {
    mypackages.rclone = {
      enable = mkEnableOption "Enable rclone";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rclone
    ];

    mypackages.impermanence.directories = [
      ".config/rclone"
    ];

    systemd.user.services.remote-mounts = {
      Unit = {
        Description = "OneDrive Personal mount service";
        After = ["network-online.target"];
      };
      Service = {
        Type = "notify";
        ExecStartPre = "${getExe' pkgs.coreutils "mkdir"} -p /mnt/OneDrivePersonal";
        ExecStart = "${getExe pkgs.rclone} --config=%h/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount \"OneDrive:\" \"/mnt/OneDrivePersonal\"";
        ExecStop = "/run/wrappers/bin/fusermount -u /mnt/OneDrivePersonal/%i";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}

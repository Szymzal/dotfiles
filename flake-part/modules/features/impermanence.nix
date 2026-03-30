{inputs, ...}: {
  flake.nixosModules.impermanence = {
    lib,
    config,
    ...
  }: let
    cfg = config.persistence;
  in {
    imports = [inputs.impermanence.nixosModules.impermanence];

    config = {
      fileSystems."${cfg.fileSystem}".neededForBoot = lib.mkThrow (cfg.fileSystem != null) "Please specify mypackages.impermanence.filesytem!";
      environment.persistence = {
        "${cfg.user.persistenceDir}".users."${cfg.user.username}" =
          if (cfg.user.persistenceDir != null && cfg.user.username != null)
          then {
            directories =
              [
                "Documents"
                ".ssh"
              ]
              ++ cfg.user.directories;
            inherit (cfg.user) files;
          }
          else throw "Please specify persistance.user.persistenceDir and persistance.user.username!";
        "${cfg.system.persistenceDir}" =
          if (cfg.system.persistenceDir != null)
          then {
            hideMounts = true;
            directories =
              [
                "/var/log"
                "/var/lib/nixos"
                "/var/lib/nixos-containers"

                "/var/lib/systemd/coredump"
                "/var/lib/systemd/timers"
                "/var/lib/machines"
                "/etc/systemd/nspawn"
              ]
              ++ cfg.directories;
            files =
              [
                "/etc/machine-id"
              ]
              ++ cfg.files;
          }
          else throw "Please specify mypackages.impermanence.persistenceDir!";
      };

      security.sudo.extraConfig = lib.mkIf cfg.disableSudoLecture ''Defaults lecture="never"'';

      programs.fuse.userAllowOther = true;

      boot.initrd.postResumeCommands =
        lib.mkIf
        (
          cfg.wipeOnBoot.enable
          && (lib.mkThrow (cfg.wipeOnBoot.virtualGroup != null) "Please specify mypackages.impermanence.wipeOnBoot.virtualGroup!")
        )
        (lib.mkAfter ''
          mkdir /btrfs_tmp
          mount ${cfg.wipeOnBoot.virtualGroup}/${cfg.wipeOnBoot.rootSubvolume} /btrfs_tmp
          if [[ -e /btrfs_tmp/${cfg.wipeOnBoot.rootSubvolume} ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/${cfg.wipeOnBoot.rootSubvolume} "/btrfs_tmp/old_roots/$timestamp"
          fi

          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
          }

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${builtins.toString cfg.wipeOnBoot.daysToDeleteOldRoots}); do
            delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/${cfg.wipeOnBoot.rootSubvolume}
          umount /btrfs_tmp
        '');
    };
  };
}

{ inputs, lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options = {
    mypackages.impermanence = {
      enable = mkEnableOption "Enable impermanence";
      fileSystem = mkOption {
        default = null;
        example = "/persist";
        description = "File system where persistence data will be stored. It is needed to mark it as neededForBoot";
        type = types.str;
      };
      persistenceDir = mkOption {
        default = null;
        example = "/persist/system";
        description = "Choose where should be stored persistence data";
        type = types.str;
      };
      disableSudoLecture = mkOption {
        default = true;
        example = false;
        description = "Disable sudo lecture entirely, so there will be no lecture after computer restart";
        type = types.bool;
      };
      wipeOnBoot = {
        enable = mkOption {
          default = false;
          example = true;
          description = "Do you want to wipe everything on boot? Support only for btrfs";
          type = types.bool;
        };
        virtualGroup = mkOption {
          default = null;
          example = "/dev/root_vg";
          description = "Disk with btrfs which have subvolumes";
          type = types.str;
        };
        rootSubvolume = mkOption {
          default = "root";
          example = "root";
          description = "Name of subvolume to wipe on boot";
          type = types.str;
        };
        daysToDeleteOldRoots = mkOption {
          default = 7;
          example = 30;
          description = "How long should old roots being kept? In days";
          type = types.int;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    fileSystems."${cfg.fileSystem}".neededForBoot = if (cfg.fileSystem != null) then true else throw "Please specify filesytem!";
    environment.persistence."${cfg.persistenceDir}" = 
      if (cfg.persistenceDir != null) then {
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/etc/NetworkManager/system-connections"
          { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
        ];
        files = [
          "/etc/machine-id"
        ];
      } else 
        throw "Please specify persistenceDir!";

    security.sudo.extraConfig = mkIf cfg.disableSudoLecture ''Defaults lecture="never"'';

    # TODO: home manager
    programs.fuse.userAllowOther = true;

    boot.initrd.postDeviceCommands = mkIf (cfg.wipeOnBoot.enable && cfg.wipeOnBoot.virtualGroup != null)
      (mkAfter ''
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
}

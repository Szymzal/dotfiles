{
  flake.nixosModules.options = {lib, ...}:
    with lib; {
      options.persistence = {
        enable = mkEnableOption "Enable impermanence";
        fileSystem = mkOption {
          default = null;
          example = "/persist";
          description = "File system where persistence data will be stored. It is needed to mark it as neededForBoot";
          type = types.str;
        };
        disableSudoLecture = mkOption {
          default = true;
          example = false;
          description = "Disable sudo lecture entirely, so there will be no lecture after computer restart";
          type = types.bool;
        };
        system = {
          directories = mkOption {
            default = [];
            example = ["/var/lib/nixos" "/var/log"];
            description = "Directories to persist. Directories needs to be absolute";
            type = types.listOf (types.either types.str types.attrs);
          };
          files = mkOption {
            default = [];
            example = ["/etc/machine-id"];
            description = "Files to persist. Files needs to be absolute";
            type = types.listOf types.str;
          };
          persistenceDir = mkOption {
            default = null;
            example = "/persist/system";
            description = "Choose where should be stored system persistence data";
            type = types.str;
          };
        };
        user = {
          username = mkOption {
            default = null;
            example = "szymzal";
            description = "Username of user to persist data";
            type = types.str;
          };
          directories = mkOption {
            default = [];
            example = ["Downloads" "dev/project"];
            description = "Directories to persist. Directories will be appended to persistent-path option";
            type = types.listOf (types.either types.str types.attrs);
          };
          files = mkOption {
            default = [];
            example = [".zshrc" ".ssh/id_rsa"];
            description = "Files to persist. File paths will be appended to persistent-path option";
            type = types.listOf types.str;
          };
          persistenceDir = mkOption {
            default = null;
            example = "/persist/user";
            description = "Choose where should be stored user persistence data";
            type = types.str;
          };
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
}

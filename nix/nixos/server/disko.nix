{
  disk.main = {
    device = "to continue";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };
        swap = {
          size = "4G";
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };
        root = {
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "root_vg";
          };
        };
      };
    };
  };
  lvm_vg = {
    root_vg = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = ["-f"];

            subvolumes = {
              "/root" = {
                mountpoint = "/";
              };

              "/persist" = {
                mountOptions = ["subvol=persist" "noatime"];
                mountpoint = "/persist";
              };

              "/nix" = {
                mountOptions = ["subvol=nix" "noatime"];
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };
  };
}

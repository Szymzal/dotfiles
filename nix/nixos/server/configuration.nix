{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) self;
in {
  imports = [
    ./hardware-configuration.nix
    self.nixosModules.modules
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  console = {
    keyMap = "pl";
  };

  time.timeZone = "Europe/Warsaw";

  nix.settings.experimental-features = ["nix-command" "flakes" "pipe-operators"];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableAllFirmware = true;

  systemd = let
    accounting = ''
      DefaultCPUAccounting=yes
      DefaultMemoryAccounting=yes
      DefaultIOAccounting=yes
    '';
  in {
    extraConfig = accounting;
    user = {
      extraConfig = accounting;
      slices = {
        "user".sliceConfig = {
          ManagedOOMSwap = "kill";
        };
        "app".sliceConfig = {
          ManagedOOMMemoryPressure = "kill";
          ManagedOOMMemoryPressureLimit = "16%";
        };
        "background".sliceConfig = {
          ManagedOOMMemoryPressure = "kill";
          ManagedOOMMemoryPressureLimit = "8%";
        };
      };
    };
    services = {
      "user@".serviceConfig = {
        Delegate = true;
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "50%";
      };
      "config-mglru" = {
        enable = true;
        after = ["basic.target"];
        wantedBy = ["sysinit.target"];
        script = let
          inherit (pkgs) coreutils;
        in ''
          ${coreutils}/bin/echo Y > /sys/kernel/mm/lru_gen/enabled
          ${coreutils}/bin/echo 1000 > /sys/kernel/mm/lru_gen/min_ttl_ms
        '';
      };
    };
    slices."background".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "8%";
    };
    oomd = {
      enable = true;
      enableRootSlice = false;
      enableSystemSlice = false;
      enableUserSlices = false;
      extraConfig = {
        DefaultMemoryPressureDurationSec = "4s";
      };
    };
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
  ];

  environment.systemPackages = with pkgs; [
    btop
  ];

  mypackages = {
    unfree.allowed = [
      "forge-loader"
    ];
    ssh.enable = true;
    networkmanager = {
      enable = true;
      hostName = "server";
      wireless = false;
    };
    gc.enable = true;
    editor.enable = true;
    git.enable = true;
    multiTerminal.enable = true;
    cachix.enable = true;
    sound.enable = true;
    fonts.enable = true;
    shell.enable = true;
    theme = {
      enable = true;
      prefer-dark-theme = true;
      theme = {
        base16-scheme-path = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      };
      cursorTheme = {
        xcursor = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
        };
        hyprcursor = {
          name = "Bibata-Modern-Classic-hyprcursor";
          package = pkgs.bibata-hyprcursor;
        };
        size = 16;
      };
      iconTheme = {
        name = "Papirus";
        package = pkgs.papirus-icon-theme;
      };
    };
    home-manager.enable = true;
    compression.enable = true;
    nix-helpers = {
      enable = true;
      flake-path = "/etc/nixos";
    };
    sops = {
      enable = true;
      defaultSopsFile = ../../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      keyFile = "/persist/home/szymzal/.config/sops/age/keys.txt";
      secrets = {
        password = {
          neededForUsers = true;
        };
      };
    };
    impermanence = {
      enable = true;
      fileSystem = "/persist";
      persistenceDir = "/persist/system";
      disableSudoLecture = true;
      wipeOnBoot = {
        enable = true;
        virtualGroup = "/dev/root_vg";
        rootSubvolume = "root";
        daysToDeleteOldRoots = 7;
      };
    };
    cd.enable = true;
    ls.enable = true;
    find.enable = true;
    network-tools.enable = true;

    ontime.server.enable = false;
    games.minecraft.server = {
      enable = true;
      servers = [];
    };
  };

  myusers.admin.enable = true;
}

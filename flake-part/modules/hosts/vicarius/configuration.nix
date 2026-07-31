{self, ...}: {
  flake.nixosModules.vicariusConfiguration = {pkgs, ...}: {
    imports = [
      self.nixosModules.options
      self.nixosModules.vicuriusHardware
      self.nixosModules.neovim
      self.nixosModules.niri
      self.nixosModules.qurio
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.dbus.implementation = "broker";

    boot.plymouth.enable = true;
    boot.supportedFilesystems = {
      ntfs = true;
      exfat = true;
      btrfs = true;
    };

    nixpkgs.config.allowUnfree = true;
    hardware.enableAllFirmware = true;

    services = {
      tailscale = {
        enable = true;
        openFirewall = true;
      };
    };

    environment.systemPackages = with pkgs; [
      ffmpeg
      btop
      nmap
      jdk8
      chromium
      qpwgraph
      mpv
      wl-clipboard
    ];

    time.hardwareClockInLocalTime = true;

    # Bootloader.
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 3;
    };
    boot.loader.efi.canTouchEfiVariables = true;

    programs.nh = {
      enable = true;
    };

    nix.settings = {
      download-speed = 15000;
      http-connections = 10;
    };

    environment = {
      sessionVariables = {
        NH_FLAKE = "/etc/nixos/dotfiles/flake-part";
      };
    };

    # Use latest kernel.
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPackages = pkgs.linuxPackages;

    networking.hostName = "vicarius"; # Define your hostname.

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Warsaw";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };

    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = false;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "pl";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "pl2";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable OpenGL / Graphics
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # For modern Intel CPUs (Broadwell and newer)
        intel-vaapi-driver # Fallback driver
        libvdpau-va-gl
      ];
    };

    # Force apps to use the modern Intel media driver
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    # Enable sound with pipewire.
    boot.kernelParams = [
      "threadirqs"
      "snd_hda_intel.power_save=0"
      "snd_hda_intel.power_save_controller=N"
      "snd_hda_intel.position_fix=1"
      "snd_intel_dspcfg.dsp_driver=1"
      "intel_idle.max_cstate=1"
      "processor.max_cstate=1"
      "preempt=full"
    ];
    security = {
      rtkit.enable = true;
      pam.loginLimits = [
        {
          domain = "@audio";
          type = "-";
          item = "rtprio";
          value = "89";
        }
        {
          domain = "@audio";
          type = "-";
          item = "nice";
          value = "-19";
        }
        {
          domain = "@audio";
          type = "-";
          item = "memlock";
          value = "4194304";
        }
      ];
    };

    systemd.user.extraConfig = ''
      DefaultLimitRTPRIO=95
      DefaultLimitMEMLOCK=4194304
    '';

    systemd.user.services = {
      pipewire.serviceConfig = {
        CPUSchedulingPolicy = "rr";
        CPUSchedulingPriority = 88;
        LimitRTPRIO = 95;
        LimitMEMLOCK = 4194304;
      };
      pipewire-pulse.serviceConfig = {
        CPUSchedulingPolicy = "rr";
        CPUSchedulingPriority = 88;
        LimitRTPRIO = 95;
        LimitMEMLOCK = 4194304;
      };
      wireplumber.serviceConfig = {
        CPUSchedulingPolicy = "rr";
        CPUSchedulingPriority = 88;
        LimitRTPRIO = 95;
        LimitMEMLOCK = 4194304;
      };
    };

    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        jack.enable = true;
        wireplumber = {
          enable = true;
        };
        extraConfig = {
          pipewire."92-dont-scratch" = {
            "context.properties" = {
              "log.level" = 3;
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [44100 48000];
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 8129;
            };
          };
        };
      };
      udev.extraRules = ''
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
        DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };

    powerManagement.cpuFreqGovernor = "performance";

    services.pulseaudio.enable = false;
    services.pipewire = {
      wireplumber.extraConfig = {
        "51-alsa-headroom" = {
          "monitor.alsa.rules" = [
            {
              matches = [{"node.name" = "~alsa_input.*";} {"node.name" = "~alsa_output.*";}];
              actions = {
                update-props = {
                  "api.alsa.disable-tsched" = true;
                  "api.alsa.period-size" = 1024;
                  "api.alsa.headroom" = 1024;
                };
              };
            }
          ];
        };
        "10-disable-suspend" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {"node.name" = "~alsa_output.*";}
              ];
              actions = {
                update-props = {
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
    };

    users.users.szymzal = {
      isNormalUser = true;
      description = "Szymzal";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "audio"];
      packages = with pkgs; [
        kdePackages.kate
      ];
    };

    # Install firefox.
    programs.firefox.enable = true;
    programs.chromium.enable = true;
    programs.foot.enable = true;
    programs.git.enable = true;
    programs.tmux.enable = true;
    programs.zsh.enable = true;

    fonts.packages = with pkgs; [nerd-fonts.fira-code];

    system.stateVersion = "25.11";
  };
}

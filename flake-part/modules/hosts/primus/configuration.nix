{self, ...}: {
  flake.nixosModules.primusConfiguration = {pkgs, ...}: {
    imports = [
      self.nixosModules.options
      self.nixosModules.primusHardware
      self.nixosModules.neovim
      self.nixosModules.niri
      # self.nixosModules.qurio
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
    hardware.bluetooth.enable = true;

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
      obs-studio
      fd
      localsend
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
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "primus"; # Define your hostname.

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
      };
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.libinput.enable = true;

    users.users.szymzal = {
      isNormalUser = true;
      description = "Szymzal";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "audio"];
      packages = with pkgs; [
        kdePackages.kate
      ];
    };

    programs.firefox.enable = true;
    programs.chromium.enable = true;
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "FiraCode Nerd Font:size=12";
        };
      };
    };
    programs.git.enable = true;
    programs.tmux.enable = true;
    programs.zsh.enable = true;

    fonts.packages = with pkgs; [nerd-fonts.fira-code];

    system.stateVersion = "26.05";
  };
}

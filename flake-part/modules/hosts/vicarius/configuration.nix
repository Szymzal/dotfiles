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

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.szymzal = {
      isNormalUser = true;
      description = "Szymzal";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel"];
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

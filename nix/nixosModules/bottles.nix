{ lib, config, pkgs, ... }: 
with lib;
let
  cfg = config.mypackages.bottles;
in
{
  options = {
    mypackages.bottles = {
      enable = mkEnableOption "Enable Bottles. A wineprefix manager";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # For whatever reason bottles package doesn't work
      # Throws an error:
      # MESA: error: CreateSwapchainKHR failed with VK_ERROR_INITIALIZATION_FAILED
      # Copy of extra packages in bottles package
      # https://github.com/NixOS/nixpkgs/blob/3c6b3fdd4d69c8893dc3bfd8dd4c97236f7e4ddd/pkgs/applications/misc/bottles/fhsenv.nix#L48
      bottles-unwrapped
      vkbasalt

      # https://wiki.winehq.org/Building_Wine
      alsa-lib
      cups
      dbus
      fontconfig
      freetype
      glib
      gnutls
      libglvnd
      gsm
      libgphoto2
      libjpeg_turbo
      libkrb5
      libpcap
      libpng
      libpulseaudio
      libtiff
      libunwind
      libusb1
      libv4l
      libxml2
      mpg123
      ocl-icd
      openldap
      samba4
      sane-backends
      SDL2
      udev
      vulkan-loader

      # https://www.gloriouseggroll.tv/how-to-get-out-of-wine-dependency-hell/
      alsa-plugins
      dosbox
      giflib
      gtk3
      libva
      libxslt
      ncurses
      openal
    ] ++ lib.optionals config.mypackages.steam.enable (with pkgs; [
      # Steam runtime
      libgcrypt
      libgpg-error
      p11-kit
      zlib # Freetype
    ]);
  };
}

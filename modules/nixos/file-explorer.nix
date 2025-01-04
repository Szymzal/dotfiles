{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  myLib = config.lib.myLib;
in {
  config = mkIf (myLib.isEnabledOptionOnHomeConfig "mypackages.file-explorer.enable") (let
    # NOTE: Why so many services have broken PATH variable? (thunar, foot)
    # script = pkgs.writeShellScript "thunar-server" ''
    #   PATH=$PATH:/etc/profiles/per-user/$USER/bin/:$HOME/.nix-profile/bin/:/run/current-system/sw/bin/
    #   $1 --daemon
    # '';
    #
    # package =
    #   ((pkgs.xfce.thunar.overrideAttrs (attrs: {
    #     buildCommand = attrs.buildCommand + ''
    #       substituteInPlace $out/lib/systemd/user/thunar.service \
    #         --replace-warn "ExecStart=" "ExecStart=${script} " \
    #         --replace-warn " --daemon" ""
    #     '';
    #   }))
    #   .override {thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ];});
  in {
    programs.dconf.enable = true;

    # environment.systemPackages = [
    #   package
    # ];
    #
    # services.dbus.packages = [
    #   package
    # ];
    #
    # systemd.packages = [
    #   package
    # ];

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin];
    };

    services.gvfs.enable = true;
  });
}

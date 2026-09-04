{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.games.roblox;
in {
  options = {
    mypackages.games.roblox = {
      enable = mkEnableOption "Enable Roblox";
    };
  };

  config = mkIf cfg.enable {
    mypackages.flatpak = {
      enable = true;
      packages = [
        "org.vinegarhq.Sober"
        # {
        #   flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        #   sha256 = "1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
        # }
      ];
    };
  };
}

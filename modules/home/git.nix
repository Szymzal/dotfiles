{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.git;
in {
  options = {
    mypackages.git = {
      enable = mkEnableOption "Enable git";
      userName = mkOption {
        default = null;
        example = "Szymzal";
        description = "Username of git user";
        type = types.str;
      };
      userEmail = mkOption {
        default = null;
        example = "szymzal05@gmail.com";
        description = "Email of git user";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      userName = cfg.userName;
      userEmail = cfg.userEmail;

      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}

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
        type = types.nullOr types.str;
      };
      userEmail = mkOption {
        default = null;
        example = "szymzal05@gmail.com";
        description = "Email of git user";
        type = types.nullOr types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
        init.defaultBranch = "main";
      };
    };
  };
}

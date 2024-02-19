{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    shellAliases = {};
    histSize = 10000;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    syntaxHighlighting.enable = true;
  };

  # Configure new shell
  environment.shells = with pkgs; [ zsh ];
}

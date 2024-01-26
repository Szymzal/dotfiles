{ ... }: {
  programs.tmux = {
    enable = true;

    escapeTime = 50;
    terminal = "screen-256color";
    extraConfig = "set-option -ga terminal-overrides \",screen-256color:Tc\"";
  };
}

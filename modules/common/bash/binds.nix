{
  programs.bash.shellInit = ''
    # zsh-like history
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
  '';
}

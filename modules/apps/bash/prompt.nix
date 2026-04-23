{ lib, ... }:

{
  # cool bash prompt
  # green for user, red for root
  programs.bash.promptInit = lib.mkDefault ''
    # Only set prompt if terminal supports it
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then

      # Color based on UID (root = red, others = green)
      if [ "$EUID" -eq 0 ]; then
        PROMPT_COLOR="1;31m"
      else
        PROMPT_COLOR="1;32m"
      fi

      if [ "$TERM" != "linux" ]; then
        PS1="\n\[\033[$PROMPT_COLOR\][\h:\w] λ\[\033[0m\] "

      else
        PS1="\n\[\033[$PROMPT_COLOR\][\h:\w] $\[\033[0m\] "

        if [ "$TERM" = "xterm" ]; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    fi
  '';
}

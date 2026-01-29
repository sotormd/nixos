{ lib, ... }:

{
  # cool bash prompt
  # looks like this:
  #
  # nixos ~ λ
  #
  # but in green
  programs.bash.promptInit = lib.mkDefault ''
    # Only set prompt if terminal supports it
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
      # Set color based on UID (root = red, others = green)
      if [ "$EUID" -eq 0 ]; then
        PROMPT_COLOR="1;31m"  # bold red
      else
        PROMPT_COLOR="1;32m"  # bold green
      fi

      if [ -n "$INSIDE_EMACS" ]; then
        # Emacs terminal mode, no title escape sequences
        PS1="\n\[\033[$PROMPT_COLOR\]\h \w λ\[\033[0m\] "
      else
        # Normal terminal, include xterm title
        PS1="\n\[\033[$PROMPT_COLOR\]\[\e]0;\u@\h: \w\a\]\h \w λ\[\033[0m\] "
      fi

      # xterm-specific additional title sequence
      if [ "$TERM" = "xterm" ]; then
        PS1="\[\033]2;\h:\u:\w\007\]$PS1"
      fi
    fi
  '';
}

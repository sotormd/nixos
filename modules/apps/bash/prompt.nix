{ lib, ... }:

{
  # cool bash prompt
  programs.bash.promptInit = lib.mkDefault ''
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then

      if [ "$EUID" -eq 0 ]; then
        PROMPT_COLOR="1;31m"
        PROMPT_SYMBOL="#"
      else
        PROMPT_COLOR="1;32m"
        if [ "$TERM" != "linux" ]; then
          PROMPT_SYMBOL="λ"
        else
          PROMPT_SYMBOL='$'
        fi
      fi

      PS1="\n\[\033[$PROMPT_COLOR\][\h:\w] $PROMPT_SYMBOL\[\033[0m\] "
    fi
  '';
}

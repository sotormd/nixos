{
  programs.bash = {
    enable = true;
    loginShellInit = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec sway
      fi
    '';
  };
}

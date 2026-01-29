{ inputs, ... }:

{
  imports = [ inputs.minimal-openbox.nixosModules.minimal-openbox ];
  programs.bash = {
    enable = true;
    loginShellInit = ''
      if [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
        exec startx
      fi
    '';
  };
}

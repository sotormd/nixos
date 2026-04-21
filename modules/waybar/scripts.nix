{ pkgs, ... }:

let
  animationScript = pkgs.writeTextFile {
    name = "waybar-script-animation";
    text = ''
      #!${pkgs.runtimeShell}

      FILE="$XDG_RUNTIME_DIR/waybar-noanimation"

      if [[ -e "$FILE" ]]; then
        rm "$FILE"
      else
        touch "$FILE"
      fi
    '';
    destination = "/animation.sh";
    executable = true;
  };

  scripts = pkgs.symlinkJoin {
    name = "waybar-scripts";
    paths = [ animationScript ];
  };
in
{
  inherit scripts;
}

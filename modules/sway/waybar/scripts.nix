{
  runtimeShell,
  symlinkJoin,
  writeTextFile,
  ...
}:

let
  animationScript = writeTextFile {
    name = "waybar-script-animation";
    text = ''
      #!${runtimeShell}

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

  scripts = symlinkJoin {
    name = "waybar-scripts";
    paths = [ animationScript ];
  };
in
scripts

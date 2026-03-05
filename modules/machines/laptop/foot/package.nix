{ config, pkgs, ... }:

let
  inherit (import ./config.nix { inherit config pkgs; }) configuration;

  footWrapperScript = pkgs.writeTextFile {
    name = "foot-wrapper-script";
    text = ''
      #!${pkgs.runtimeShell}

      FOCUSED_OUT="$(swaymsg -t get_outputs -r | jq -r '.[] | select(.focused == true).name')"

      if [ "$FOCUSED_OUT" = "${config.vars.displays.outputs.laptop.identifier}" ]; then
        SIZE=7
      else
        SIZE=10
      fi

      ${pkgs.foot}/bin/foot --config=${configuration}/foot.ini --font "${config.colors.fonts.monospace}:size=$SIZE" "$@"
    '';
    destination = "/bin/foot";
    executable = true;
  };

  footWrapped = pkgs.symlinkJoin {
    name = "foot";
    paths = [ pkgs.foot ];

    # replace the foot binary with our wrapper
    postBuild = ''
      rm -f $out/bin/foot
      ln -s ${footWrapperScript}/bin/foot $out/bin/foot
    '';
  };
in
{
  inherit footWrapped;
}

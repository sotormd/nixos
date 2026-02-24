{ config, pkgs, ... }:

let
  configuration = import ./config.nix { inherit config pkgs; };
  footWrapped = pkgs.writeShellScriptBin "foot" ''
    FOCUSED_OUT="$(${pkgs.swayfx}/bin/swaymsg -t get_outputs -r | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true).name')"

    if [ "$FOCUSED_OUT" = "${config.vars.displays.outputs.laptop.identifier}" ]; then
      SIZE=7
    else
      SIZE=10
    fi

    ${pkgs.foot}/bin/foot --config=${configuration.configDir}/foot.ini --font "${config.colors.fonts.monospace}:size=$SIZE" "$@"
  '';
in
{
  foot = pkgs.symlinkJoin {
    name = "foot";
    paths = [ pkgs.foot ];

    # replace the foot binary with our wrapper
    postBuild = ''
      rm -f $out/bin/foot
      ln -s ${footWrapped}/bin/foot $out/bin/foot
    '';
  };
}

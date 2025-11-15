{
  pkgs,
  colors,
  vars,
  ...
}:

let
  config = import ./config.nix { inherit pkgs colors; };
in
{
  foot = pkgs.writeShellScriptBin "foot" ''
    #! ${pkgs.runtimeShell}

    FOCUSED_OUT="$(${pkgs.swayfx}/bin/swaymsg -t get_outputs -r | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true).name')"

    if [ "$FOCUSED_OUT" = "${vars.outputs.laptop}" ]; then
      SIZE=7
    else
      SIZE=10
    fi

    ${pkgs.foot}/bin/foot --config=${config.configDir}/foot.ini --font "${colors.fonts.monospace}:size=$SIZE" "$@"
  '';
}

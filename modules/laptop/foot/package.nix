{
  config,
  pkgs,
  vars,
  ...
}:

let
  configuration = import ./config.nix { inherit config pkgs; };
in
{
  foot = pkgs.writeShellScriptBin "foot" ''
    #!/usr/bin/env ${pkgs.runtimeShell}

    FOCUSED_OUT="$(${pkgs.swayfx}/bin/swaymsg -t get_outputs -r | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true).name')"

    if [ "$FOCUSED_OUT" = "${vars.outputs.laptop}" ]; then
      SIZE=7
    else
      SIZE=10
    fi

    ${pkgs.foot}/bin/foot --config=${configuration.configDir}/foot.ini --font "${config.colors.fonts.monospace}:size=$SIZE" "$@"
  '';
}

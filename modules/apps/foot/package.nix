{
  lib,
  foot,
  callPackage,
  configuration,
}:

let
  inherit (lib) colors;

  name = "foot";
  base = foot;
  command = ''
    FOCUSED_OUT="$(swaymsg -t get_outputs -r | jq -r '.[] | select(.focused == true).name')"

    if [ "$FOCUSED_OUT" = "eDP-1" ]; then
      SIZE=7
    else
      SIZE=10
    fi

    ${lib.getExe base} --config=${configuration} --font "${colors.fonts.monospace}:size=$SIZE" "$@"
  '';

  footWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
footWrapped

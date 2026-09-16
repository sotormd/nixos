{
  lib,
  waybar,
  callPackage,
  configuration,
  style,
}:

let
  name = "waybar";
  base = waybar;
  command = ''
    ${lib.getExe base} --config ${configuration} --style ${style} "$@"
  '';

  waybarWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
waybarWrapped

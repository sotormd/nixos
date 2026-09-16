{
  lib,
  sway,
  callPackage,
  configuration,
}:

let
  name = "sway";
  base = sway;
  command = ''
    ${lib.getExe base} --config ${configuration} "$@"
  '';

  swayWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
swayWrapped

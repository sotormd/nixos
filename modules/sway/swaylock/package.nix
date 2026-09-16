{
  lib,
  swaylock,
  xkcd0,
  callPackage,
  configuration,
}:

let
  name = "swaylock";
  base = swaylock;
  command = ''
    ${lib.getExe swaylock} --config ${configuration} "$@"
    ${lib.getExe xkcd0}
  '';

  swaylockWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
swaylockWrapped

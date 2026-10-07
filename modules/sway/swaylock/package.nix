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
  type = "command";
  command = ''
    ${lib.getExe swaylock} --config ${configuration} "$@"
    ${lib.getExe xkcd0}
  '';

  swaylockWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      command
      ;
  };
in
swaylockWrapped

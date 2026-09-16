{
  lib,
  dunst,
  callPackage,
  configuration,
}:

let
  name = "dunst";
  base = dunst;
  command = ''
    ${lib.getExe base} -config ${configuration} "$@"
  '';

  dunstWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
dunstWrapped

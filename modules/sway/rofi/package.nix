{
  lib,
  rofi,
  callPackage,
  configuration,
}:

let
  name = "rofi";
  base = rofi;
  command = ''
    ${lib.getExe base} -config ${configuration} "$@"
  '';

  rofiWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
rofiWrapped

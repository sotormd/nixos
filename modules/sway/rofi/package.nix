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
    ${lib.getExe base} -config ${configuration}/config.rasi "$@"
  '';

  rofiWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
rofiWrapped

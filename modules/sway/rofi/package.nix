{
  lib,
  rofi,
  callPackage,
  configuration,
}:

let
  name = "rofi";
  base = rofi;
  type = "wrapper";
  args = ''
    --append-flags "-config ${configuration}"
  '';

  rofiWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
rofiWrapped

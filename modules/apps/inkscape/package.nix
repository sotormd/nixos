{
  lib,
  inkscape,
  callPackage,
  configuration,
}:

let
  name = "inkscape";
  base = inkscape;
  type = "wrapper";
  args = ''
    --set INKSCAPE_PROFILE_DIR ${configuration}
  '';

  inkscapeWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
inkscapeWrapped

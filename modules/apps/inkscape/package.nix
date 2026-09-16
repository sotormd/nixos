{
  lib,
  inkscape,
  callPackage,
  configuration,
}:

let
  name = "inkscape";
  base = inkscape;
  command = ''
    env INKSCAPE_PROFILE_DIR="${configuration}" ${lib.getExe base} "$@"
  '';

  inkscapeWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
inkscapeWrapped

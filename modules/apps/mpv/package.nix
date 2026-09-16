{
  lib,
  mpv,
  callPackage,
  configuration,
  scripts,
}:

let
  mpvWithScripts = mpv.override { inherit scripts; };

  name = "mpv";
  base = mpvWithScripts;
  command = ''
    ${lib.getExe base} --config-dir=${configuration} "$@"
  '';

  mpvWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
mpvWrapped

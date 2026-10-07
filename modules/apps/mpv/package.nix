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
  type = "wrapper";
  args = ''
    --append-flags "--config-dir=${configuration}"
  '';

  mpvWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
mpvWrapped

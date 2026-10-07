{
  lib,
  waybar,
  callPackage,
  configuration,
  style,
}:

let
  name = "waybar";
  base = waybar;
  type = "wrapper";
  args = ''
    --append-flags "--config ${configuration} --style ${style}"
  '';

  waybarWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
waybarWrapped

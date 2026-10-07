{
  lib,
  sway,
  callPackage,
  configuration,
}:

let
  name = "sway";
  base = sway;
  type = "wrapper";
  args = ''
    --append-flags "--config ${configuration}"
  '';

  swayWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
swayWrapped

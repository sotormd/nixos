{
  lib,
  zathura,
  callPackage,
  configuration,
}:

let
  name = "zathura";
  base = zathura;
  type = "wrapper";
  args = ''
    --append-flags "--config-dir=${configuration}"
  '';

  zathuraWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
zathuraWrapped

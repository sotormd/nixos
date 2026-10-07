{
  lib,
  btop,
  callPackage,
  configuration,
}:

let
  name = "btop";
  base = btop;
  type = "wrapper";
  args = ''
    --append-flags "--config ${configuration}"
  '';

  btopWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
btopWrapped

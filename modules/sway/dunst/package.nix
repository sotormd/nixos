{
  lib,
  dunst,
  callPackage,
  configuration,
}:

let
  name = "dunst";
  base = dunst;
  type = "wrapper";
  args = ''
    --append-flags "-config ${configuration}"
  '';

  dunstWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      args
      ;
  };
in
dunstWrapped

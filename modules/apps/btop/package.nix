{
  lib,
  btop,
  callPackage,
  configuration,
}:

let
  name = "btop";
  base = btop;
  command = ''
    ${lib.getExe base} --config ${configuration} "$@"
  '';

  btopWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
btopWrapped

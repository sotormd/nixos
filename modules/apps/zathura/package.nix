{
  lib,
  zathura,
  callPackage,
  configuration,
}:

let
  name = "zathura";
  base = zathura;
  command = ''
    ${lib.getExe base} --config-dir=${configuration} "$@"
  '';

  zathuraWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
zathuraWrapped

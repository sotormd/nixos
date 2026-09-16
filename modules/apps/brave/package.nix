{
  lib,
  callPackage,
  executable,
  jail,
}:

let
  name = "brave";
  base = executable;
  command = jail;

  braveWrapped = callPackage lib.mkWrapperPackage { inherit name base command; };
in
braveWrapped

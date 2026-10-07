{
  lib,
  callPackage,
  executable,
  jail,
}:

let
  name = "brave";
  base = executable;
  type = "command";
  command = jail;

  braveWrapped = callPackage lib.mkWrapperPackage {
    inherit
      name
      base
      type
      command
      ;
    keepNoConfig = false; # will cause race on profile
  };
in
braveWrapped

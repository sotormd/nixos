{
  lib,
  callPackage,
  executable,
  logger,
}:

let
  name = "brave";
  base = executable;
  type = "command";
  command = logger;

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

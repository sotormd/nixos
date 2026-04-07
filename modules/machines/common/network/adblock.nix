{ inputs, lib, ... }:

let
  combined = builtins.readFile (inputs.hosts.outPath + "/alternates/fakenews-gambling-porn/hosts");

  cleaned = lib.concatStringsSep "\n" (
    lib.filter (line: !(lib.hasInfix "::" line)) (lib.splitString "\n" combined)
  );

in
{
  networking.extraHosts = cleaned;
}

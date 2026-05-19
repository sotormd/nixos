{
  inputs,
  config,
  lib,
  ...
}:

let
  inherit (config.vars.services) unbound;

  hosts = builtins.readFile "${inputs.hosts.outPath}/alternates/fakenews-gambling-porn/hosts";

  block_hosts = lib.filter (
    x: lib.strings.hasPrefix "0.0.0.0" x && !(lib.strings.hasSuffix "0.0.0.0" x)
  ) (lib.strings.splitString "\n" hosts);

  block_domains = lib.map (x: (builtins.elemAt (lib.strings.splitString " " x) 1)) block_hosts;

  unboundLocalZone = lib.map (d: ''"${d}." static'') block_domains;

  unboundLocalData = lib.map (d: ''"${d}. IN A 0.0.0.0"'') block_domains;
in
{
  config = lib.mkIf unbound.enable {

    services.unbound.settings = {
      local-zone = unboundLocalZone;
      local-data = unboundLocalData;
    };

  };
}

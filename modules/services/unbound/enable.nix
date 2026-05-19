{ config, lib, ... }:

let
  inherit (config.vars.services) unbound;
in
{
  config = lib.mkIf unbound.enable {

    services.unbound.enable = true;

  };
}

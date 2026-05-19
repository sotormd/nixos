{ config, lib, ... }:

let
  inherit (config.vars.services) unbound;
  inherit (lib.ports) external;
in
{
  config = lib.mkIf unbound.enable {

    services.unbound.settings.server = {
      interface = [ "0.0.0.0" ];
      port = external.unbound.dns;
    };

  };
}

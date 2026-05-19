{ config, lib, ... }:

let
  inherit (config.vars.services) searxng;
  inherit (lib.ports) internal;
in
{
  config = lib.mkIf searxng.enable {

    services.searx = {
      settings.server = {
        port = internal.searxng.search-engine;
        bind_address = "0.0.0.0";
      };
      configureUwsgi = false;
    };

  };
}

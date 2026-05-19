{ config, lib, ... }:

let
  inherit (config.vars.services) searxng;
  inherit (lib) ports;
in
lib.mkIf searxng.enable {

  services.searx = {
    settings.server = {
      bind_address = "127.0.0.1";
      port = ports.searxng.search-engine;
    };
  };

}

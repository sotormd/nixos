{ inputs, ... }:

let
  inherit (inputs.self.nixosModules.modules) network services;
in
{
  imports = [
    network.stevenblack
    services.i2pd
    services.jellyfin
    services.nginx
    services.qbt
    services.searxng
    services.unbound
    services.vaultwarden
  ];
}

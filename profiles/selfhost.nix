{ inputs, ... }:

let
  inherit (inputs.self.nixosModules.modules) services;
in
{
  imports = [
    services.i2pd
    services.jellyfin
    services.nginx
    services.qbt
    services.searxng
    services.unbound
    services.vaultwarden
  ];
}

{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.network.stevenblack
    m.services.i2pd
    m.services.jellyfin
    m.services.nginx
    m.services.qbt
    m.services.searxng
    m.services.unbound
    m.services.vaultwarden
  ];
}

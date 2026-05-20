{ self, ... }:

let
  inherit (self.nixosModules.modules) firewall services svcvm;
in
{
  imports = [
    firewall.svcvm
    services.i2pd
    services.jellyfin
    services.nginx
    services.qbt
    services.searxng
    services.unbound
    services.vaultwarden
    svcvm.schema
  ];
}

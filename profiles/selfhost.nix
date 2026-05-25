{ self, ... }:

let
  inherit (self.nixosModules.modules) services;
in
{
  imports = [
    services.jellyfin
    services.nginx
    services.qbt
    services.searxng
    services.vaultwarden
  ];
}

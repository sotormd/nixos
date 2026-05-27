{ self, ... }:

let
  inherit (self.nixosModules.modules) svcvm;
in
{
  imports = [
    svcvm.i2pd
    svcvm.nginx
    svcvm.qbt
    svcvm.searxng
    svcvm.unbound
    svcvm.vaultwarden
  ];
}

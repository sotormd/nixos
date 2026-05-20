{ self, ... }:

let
  inherit (self.nixosModules.modules) boot core svcvm;
in
{
  imports = [
    boot.kernel
    boot.malloc
    core.state
    svcvm.guest
    svcvm.schema
  ];
}

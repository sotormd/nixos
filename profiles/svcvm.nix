{ self, ... }:

let
  inherit (self.nixosModules.modules) apps boot core;
in
{
  imports = [
    apps.bash
    boot.kernel
    boot.malloc
    core.state
  ];
}

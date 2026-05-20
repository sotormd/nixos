{ self, ... }:

let
  inherit (self.nixosModules.modules) boot network;
in
{
  imports = [
    boot.uboot
    network.ready
    network.stevenblack
  ];
}

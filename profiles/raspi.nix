{ self, ... }:

let
  inherit (self.nixosModules.modules) boot;
in
{
  imports = [
    boot.uboot
  ];
}

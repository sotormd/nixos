{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.boot.uboot
  ];
}

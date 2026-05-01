{ inputs, ... }:

let
  inherit (inputs.self.nixosModules.modules) boot;
in
{
  imports = [
    boot.uboot
  ];
}

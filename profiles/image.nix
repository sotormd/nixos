{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.bootstrap.image
    m.core.cli
    m.core.nix
    m.core.packages
  ];
}

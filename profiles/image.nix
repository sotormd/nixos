{ inputs, ... }:

let
  m = inputs.self.nixosModules.modules;
in
{
  imports = [
    m.bootstrap.user
    m.core.cli
    m.core.nix
    m.core.packages
    m.network.networkmanager
  ];
}

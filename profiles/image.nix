{ inputs, ... }:

let
  inherit (inputs.self.nixosModules.modules) bootstrap core network;
in
{
  imports = [
    bootstrap.fs
    bootstrap.user
    core.cli
    core.nix
    core.packages
    core.state
    network.networkmanager
  ];
}

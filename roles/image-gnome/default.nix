{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.nixosModules.bootstrap-image
    inputs.nixosModules.cli-bin
    inputs.nixosModules.nix
    inputs.nixosModules.packages
  ];
}

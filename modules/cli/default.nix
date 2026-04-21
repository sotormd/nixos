{ inputs, ... }:

{
  imports = [
    ./dir.nix
    ./env.nix
    inputs.nixosModules.cli-bin
  ];
}

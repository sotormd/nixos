{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.self.nixosModules.bootstrap-image
    inputs.self.nixosModules.cli-bin
    inputs.self.nixosModules.nix
    inputs.self.nixosModules.packages
  ];
}

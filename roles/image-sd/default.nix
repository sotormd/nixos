{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.self.nixosModules.bootstrap-image
    inputs.self.nixosModules.cli
    inputs.self.nixosModules.nix
    inputs.self.nixosModules.packages
    inputs.self.nixosModules.quietboot
  ];
}

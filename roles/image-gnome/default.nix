{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.self.nixosModules.modules.bootstrap.graphical
    inputs.self.nixosModules.profiles.image
  ];
}

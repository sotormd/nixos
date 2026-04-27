{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.nate.nixosModules.nate
    inputs.self.nixosModules.modules.bootstrap.graphical
    inputs.self.nixosModules.profiles.image
  ];
}

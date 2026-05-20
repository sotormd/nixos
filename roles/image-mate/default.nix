{ inputs, self, ... }:

{
  imports = [
    ./configuration.nix
    inputs.nate.nixosModules.nate
    self.nixosModules.modules.bootstrap.graphical
    self.nixosModules.profiles.image
  ];
}

{ self, ... }:

{
  imports = [
    ./configuration.nix
    self.nixosModules.modules.bootstrap.graphical
    self.nixosModules.profiles.image
  ];
}

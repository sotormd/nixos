{ self, ... }:

{
  imports = [
    ./configuration.nix
    self.nixosModules.profiles.image
  ];
}

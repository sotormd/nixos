{ self, ... }:

{
  imports = [
    ./configuration.nix
    self.nixosModules.modules.boot.quiet
    self.nixosModules.profiles.image
  ];
}

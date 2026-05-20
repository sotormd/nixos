{ self, ... }:

{
  imports = [
    self.nixosModules.image-minimal
    self.nixosModules.modules.bootstrap.remote
  ];
}

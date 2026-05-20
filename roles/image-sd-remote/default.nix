{ self, ... }:

{
  imports = [
    self.nixosModules.image-sd
    self.nixosModules.modules.bootstrap.remote
  ];
}

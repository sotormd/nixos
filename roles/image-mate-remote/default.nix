{ self, ... }:

{
  imports = [
    self.nixosModules.image-mate
    self.nixosModules.modules.bootstrap.remote
  ];
}

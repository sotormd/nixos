{ self, ... }:

{
  imports = [
    self.nixosModules.roles.image-sd
    self.nixosModules.modules.bootstrap.remote
  ];
}

{ self, ... }:

{
  imports = [
    self.nixosModules.roles.image-minimal
    self.nixosModules.modules.bootstrap.remote
  ];
}

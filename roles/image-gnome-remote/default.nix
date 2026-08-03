{ self, ... }:

{
  imports = [
    self.nixosModules.roles.image-gnome
    self.nixosModules.modules.bootstrap.remote
  ];
}

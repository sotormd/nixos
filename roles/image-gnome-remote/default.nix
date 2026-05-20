{ self, ... }:

{
  imports = [
    self.nixosModules.image-gnome
    self.nixosModules.modules.bootstrap.remote
  ];
}

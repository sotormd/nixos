{ self, ... }:

{
  imports = [
    ./configuration.nix
    self.nixosModules.modules.bootstrap.graphical
    self.nixosModules.modules.desktop.gnome
    self.nixosModules.profiles.image
  ];
}

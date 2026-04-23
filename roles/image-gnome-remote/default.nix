{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.image-gnome
    inputs.self.nixosModules.modules.bootstrap.remote
  ];
}

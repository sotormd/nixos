{ inputs, ... }:

{
  imports = [
    inputs.nixosModules.bootstrap-remote
    inputs.nixosModules.image-gnome
  ];
}

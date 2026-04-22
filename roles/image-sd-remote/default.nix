{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.bootstrap-remote
    inputs.self.nixosModules.image-sd
  ];
}

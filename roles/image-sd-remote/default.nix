{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.image-sd
    inputs.self.nixosModules.modules.bootstrap.remote
  ];
}

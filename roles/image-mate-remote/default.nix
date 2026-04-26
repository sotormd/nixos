{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.image-mate
    inputs.self.nixosModules.modules.bootstrap.remote
  ];
}

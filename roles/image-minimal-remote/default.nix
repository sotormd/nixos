{ inputs, ... }:

{
  imports = [
    inputs.self.nixosModules.image-minimal
    inputs.self.nixosModules.modules.bootstrap.remote
  ];
}

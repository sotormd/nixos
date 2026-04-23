{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.self.nixosModules.modules.quietboot
    inputs.self.nixosModules.profiles.image
  ];
}

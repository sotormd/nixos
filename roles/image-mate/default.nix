{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.nate.nixosModules.nate
    inputs.self.nixosModules.profiles.image
  ];
}

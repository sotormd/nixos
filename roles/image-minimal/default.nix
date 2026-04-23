{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.self.nixosModules.profiles.image
  ];
}

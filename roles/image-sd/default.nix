{ inputs, ... }:

{
  imports = [
    ./configuration.nix
    inputs.self.nixosModules.modules.boot.quiet
    inputs.self.nixosModules.profiles.image
  ];
}

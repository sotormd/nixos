{ inputs, legacyVars, ... }:

{
  imports = [
    ./impermanence
    ./configuration.nix
    inputs.colors.nixosModules.colors
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    inputs.wallpapers.nixosModules.wallpapers
    inputs.self.nixosModules.profiles.desktop
    inputs.self.nixosModules.profiles.laptop
    inputs.self.nixosModules.profiles.machine
  ];

  # populate the variables
  vars = legacyVars;
}

{ inputs, ... }:

{
  imports = [
    ./impermanence
    ./configuration.nix
    ./specialisations.nix
    inputs.colors.nixosModules.colors
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    inputs.wallpapers.nixosModules.wallpapers
    inputs.self.nixosModules.profiles.desktop
    inputs.self.nixosModules.profiles.machine
    inputs.self.nixosModules.profiles.workstation
  ];
}

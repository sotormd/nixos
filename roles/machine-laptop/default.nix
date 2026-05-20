{ inputs, self, ... }:

{
  imports = [

    ./impermanence
    ./specialisations

    ./configuration.nix

    inputs.colors.nixosModules.colors
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    inputs.wallpapers.nixosModules.wallpapers

    self.nixosModules.profiles.desktop
    self.nixosModules.profiles.machine
    self.nixosModules.profiles.workstation

  ];
}

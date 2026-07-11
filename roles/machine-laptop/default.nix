{ inputs, self, ... }:

{
  imports = [

    ./specialisations
    ./configuration.nix
    ./impermanence.nix

    inputs.colors.nixosModules.colors
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    inputs.wallpapers.nixosModules.wallpapers

    self.nixosModules.profiles.desktop
    self.nixosModules.profiles.efitop
    self.nixosModules.profiles.machine

  ];
}

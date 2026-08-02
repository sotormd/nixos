{ inputs, self, ... }:

{
  imports = [

    ./specialisations
    ./configuration.nix
    ./impermanence.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops

    self.nixosModules.profiles.desktop
    self.nixosModules.profiles.laptop
    self.nixosModules.profiles.machine

  ];
}

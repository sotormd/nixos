{ inputs, self, ... }:

{
  imports = [

    ./impermanence

    ./configuration.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.microvm-nix.nixosModules.host
    inputs.sops-nix.nixosModules.sops

    self.nixosModules.profiles.efitop
    self.nixosModules.profiles.machine
    self.nixosModules.profiles.selfhost

  ];
}

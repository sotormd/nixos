{ inputs, self, ... }:

{
  imports = [

    ./configuration.nix
    ./impermanence.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    inputs.svcvm.nixosModules.host

    self.nixosModules.profiles.laptop
    self.nixosModules.profiles.machine
    self.nixosModules.profiles.selfhost

  ];
}

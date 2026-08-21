{ inputs, self, ... }:

{
  imports = [

    ../configuration.nix
    ../impermanence.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.profiles.deskspec

    ./common.nix

  ];
}

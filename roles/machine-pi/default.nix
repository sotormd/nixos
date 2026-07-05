{ inputs, self, ... }:

{
  imports = [

    ./impermanence

    ./configuration.nix

    inputs.sops-nix.nixosModules.sops

    self.nixosModules.profiles.machine
    self.nixosModules.profiles.raspi

  ];
}

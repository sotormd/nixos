{ inputs, self, ... }:

{
  imports = [

    ./impermanence

    ./configuration.nix

    inputs.microvm-nix.nixosModules.host
    inputs.sops-nix.nixosModules.sops

    self.nixosModules.profiles.machine
    self.nixosModules.profiles.raspi
    self.nixosModules.profiles.selfhost

  ];
}

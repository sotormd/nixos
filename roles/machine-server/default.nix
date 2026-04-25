{ inputs, legacyVars, ... }:

{
  imports = [
    ./impermanence
    ./configuration.nix
    inputs.hosts.nixosModule
    inputs.sops-nix.nixosModules.sops
    inputs.self.nixosModules.profiles.machine
    inputs.self.nixosModules.profiles.selfhost
    inputs.self.nixosModules.profiles.raspi
  ];

  # populate the variables
  vars = legacyVars;
}

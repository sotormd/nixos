{ inputs, legacyVars, ... }:

{
  imports = [
    ./impermanence
    ./configuration.nix
    inputs.hosts.nixosModule
    inputs.sops-nix.nixosModules.sops
    inputs.self.nixosModules.profiles.machine
    inputs.self.nixosModules.profiles.raspi
    inputs.self.nixosModules.profiles.selfhost
  ];

  # populate the variables
  vars = legacyVars;
}

{ inputs, legacyVars, ... }:

{
  imports = [
    ./impermanence
    ./configuration.nix
    inputs.hosts.nixosModule
    inputs.sops-nix.nixosModules.sops
    inputs.self.nixosModules.profiles.machine
    inputs.self.nixosModules.profiles.pi
    inputs.self.nixosModules.profiles.selfhost
  ];

  # populate the variables
  vars = legacyVars;
}

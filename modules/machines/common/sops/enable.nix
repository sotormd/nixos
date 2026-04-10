{ inputs, pkgs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  environment.systemPackages = [ pkgs.sops ];
}

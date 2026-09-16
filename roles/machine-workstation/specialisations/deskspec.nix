{
  inputs,
  self,
  lib,
  ...
}:

{
  imports = [

    ../configuration.nix
    ../impermanence.nix

    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.profiles.deskspec

    ./common.nix

  ];

  # lib overlay
  # deskspecs dont inherit parent config
  nixpkgs.overlays = [ (_: _: { inherit lib; }) ];
}

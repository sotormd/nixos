{ pkgs, ... }:

let
  package = import ./bin.nix { inherit pkgs; };

  finalPackage = pkgs.symlinkJoin {
    name = "nixos";
    paths = [ package.nixosWrapper ];
    postBuild = ''
      mkdir -p $out/share/man/man1
      install -m644 ${./nixos.1} $out/share/man/man1/nixos.1
    '';
  };
in
{
  imports = [
    ./dir.nix

    ./env.nix
  ];

  environment.systemPackages = [ finalPackage ];
}
